$ErrorActionPreference = 'Stop'

if ((Get-ProcessorBits) -ne '64') {
   Throw 'This package requires a 64-bit processor!'
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = 'Text-Grab-x64-Self-Contained.zip'
$DestinationFolder = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $UnZipArgs = @{
      packageName   = $env:ChocolateyPackageName
      URL64bit      = 'https://github.com/TheJoeFin/Text-Grab/releases/download/v4.16.0/Text-Grab-arm64-Self-Contained.zip'
      UnzipLocation = $DestinationFolder
      Checksum64    = 'e1f5c82135030bfe4c2e4eedfbf2747d1d45b36ea97a35bd30e53e75b6bb75f7'
   }
   Get-ChocolateyUnzip @downloadArgs
}
else {
   $UnZipArgs = @{
      packageName    = $env:ChocolateyPackageName
      FileFullPath   = Join-Path $toolsDir $ZipFile
      Destination    = $DestinationFolder
   }
   Get-ChocolateyUnzip @UnZipArgs
}

Remove-Item (Join-Path $toolsDir $ZipFile) -Force 

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\Text-Grab.lnk'
   TargetPath       = (Get-ChildItem $DestinationFolder -filter *.exe -Recurse).fullname
}
Install-ChocolateyShortcut @ShortcutArgs
