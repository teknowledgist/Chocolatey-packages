$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir
$BitLevel = Get-ProcessorBits

# Remove old versions
$null = Get-ChildItem $FolderOfPackage -Filter *.exe | Remove-Item -Force

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   # This is required until Chocolatey-AU "Get-RemoteFiles" also gets ARM64 files.
   $DLArgs = @{
      packageName         = $env:ChocolateyPackageName
      URL64bit            = 'https://github.com/praat/praat.github.io/releases/download/v6.4.62/praat6462_win-arm64.zip'
      FileFullPath        = "$toolsDir\Praat_ARM64.zip"
      Checksum64          = '4ec90be7af1e59dfc40cff87470a63fc030933fc0f48f9d820cb215feda3a3e9'
      GetOriginalFileName = $true
   }
   $null = Get-ChocolateyWebFile @DLArgs

   $LookFor = 'arm64'
} elseif ($Bitlevel -eq '64') { $LookFor = 'intel64' }
else {$LookFor = 'intel32'}

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Where-Object {$_.basename -match "$LookFor`$"} | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $FolderOfPackage

$Linkname = (Get-Culture).textinfo.totitlecase($env:ChocolateyPackageName) + '.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname
$targetPath = (Get-ChildItem $FolderOfPackage -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $FolderOfPackage -filter *.exe |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}

Get-ChildItem $toolsDir -filter '*.zip' | ForEach-Object {Remove-Item $_.fullname -force}
