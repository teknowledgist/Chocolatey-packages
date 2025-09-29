$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}
# Identify embedded files (even if they won't be used) to be removed later
$ZipFiles = Get-ChildItem $toolsDir -filter *.zip | 
               Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 2

$Destination = (Join-path $FolderOfPackage ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))

. $toolsDir\helpers.ps1
$Features = Get-ProcessorFeatures

# Set defaults
$PC32 = 'Win32'
$PC64 = 'x64'
$HD   = 'HD'
$Lang = 'i18n'

if ($Features.'AVX2_INSTRUCTIONS') {
   $PC64 = 'AVX2'
} elseif ($Features.'ARM_V8_INSTRUCTIONS') {
   $PC32 = 'ARM'
   $PC64 = 'ARM64'
}

$pp = Get-PackageParameters
if ($pp['Language'] -or $pp['LowRes'] -or ($PC32 -ne 'Win32') -or ($PC64 -ne 'AVX2')) { 
   $Builds = Import-Csv "$toolsDir\BuildChecksums.csv" 

   if ($pp['LowRes']) { $HD = '' }

   if ($pp['Language']) { 
      Write-Host "Language '$($pp['Language'])' requested." -ForegroundColor Cyan
      $Lang = $Builds | Where-Object {$_.Language -match $pp['Language']} | 
                        Select-Object -ExpandProperty Language -Unique -First 1
   }
   if ($Lang) {
      Write-Verbose "Language '$Lang' identified."
   } else {
      Write-Warning "No language found for '$($pp['language'])'."
      Write-Warning "Default, multi-language build will be used."
      $Lang = 'i18n'
   }

   $Item64 = $Builds | Where-Object {
                        ($_.HD -eq $HD) -and 
                        ($_.Language -eq $Lang) -and
                        ($_.Processor -eq $PC64)
                     }
   $Item32 = $Builds | Where-Object {
                        ($_.language -match $Lang) -and
                        ($_.Processor -eq $PC32)
                     }

   $ZipArgs = @{
      PackageName   = 'Notepad4'
      URL           = $Item32.URL
      URL64bit      = $Item64.URL
      Checksum      = $Item32.SHA256
      Checksum64    = $Item64.SHA256
      ChecksumType  = 'SHA256'
      UnzipLocation = $Destination
   }
   Install-ChocolateyZipPackage @ZipArgs
}
else {
   $Zip64File = $ZipFiles | Where-Object {$_ -notmatch 'Win32'}
   $Zip32File = $ZipFiles | Where-Object {$_ -match 'Win32'}
   $UnzipArgs = @{
      PackageName    = $env:ChocolateyPackageName
      FileFullPath   = $Zip32File
      FileFullPath64 = $Zip64File
      Destination    = $Destination
   }
   Get-ChocolateyUnzip @UnzipArgs
}

# Delete the embedded binaries
$ZipFiles | ForEach-Object {Remove-Item $_ -Force}

$SCArgs = @{
   shortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\Notepad4.lnk'
   targetPath       = (Get-ChildItem $Destination -filter 'Notepad4.exe' -Recurse).fullname
   WorkingDirectory = '%APPDATA%'
}
Install-ChocolateyShortcut @SCArgs

# For future user profiles
$Default = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList').Default
if (-not (Test-Path "$Default\AppData\Local\Notepad4")) {
   New-Item "$Default\AppData\Local\Notepad4" -ItemType Directory -Force
}
# For current, installing user (but not if SYSTEM)
if (("$env:COMPUTERNAME$" -ne "$env:USERNAME") -and
      (-not (Test-Path "$env:LOCALAPPDATA\Notepad4"))) {
   New-Item "$env:LOCALAPPDATA\Notepad4" -ItemType Directory -Force
}
# Adjust .ini files for personalized preferences
$INIs = Get-ChildItem $FolderOfPackage -filter '*.ini' -Recurse
$RegEx = '^;(.*\.ini)$'
Foreach ($file in $INIs) {
   (Get-Content $file.fullname) -replace $regex,'$1' | Set-Content $file.fullname

   Copy-Item $file.FullName "$Default\AppData\Local\Notepad4\$($file.Name)" -Force
   # also for current user (but not SYSTEM) if not currently present
   if (("$env:COMPUTERNAME$" -ne "$env:USERNAME") -and 
         (-not (Test-Path "$env:LOCALAPPDATA\Notepad4\$($file.Name)"))) {
      Copy-Item $file.FullName "$env:LOCALAPPDATA\Notepad4\$($file.Name)" -Force
   }
   
}
