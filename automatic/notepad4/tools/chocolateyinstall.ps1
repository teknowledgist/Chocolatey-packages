$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFiles = Get-ChildItem $toolsDir -filter *.zip | 
               Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 2

$UnzipArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFiles | Where-Object {$_ -notmatch 'x64'}
   FileFullPath64 = $ZipFiles | Where-Object {$_ -match 'x64'}
   Destination    = (Join-path $FolderOfPackage ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))
}
Get-ChocolateyUnzip @UnzipArgs
$ZipFiles | ForEach-Object {Remove-Item $_ -Force}

$Linkname = 'Notepad4.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$SCArgs = @{
   shortcutFilePath = Join-Path $StartPrograms $Linkname
   targetPath       = (Get-ChildItem $FolderOfPackage -filter 'Notepad4.exe' -Recurse).fullname
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
