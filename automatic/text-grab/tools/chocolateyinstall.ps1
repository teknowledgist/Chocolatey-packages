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

$ZipFile = 'Text-Grab-x64-Self-Contained-2025-12-18.zip'
$DestinationFolder = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $UnZipArgs = @{
      packageName   = $env:ChocolateyPackageName
      URL64bit      = 'https://github.com/TheJoeFin/Text-Grab/releases/download/v4.11.2/Text-Grab-Arm64-Self-Contained-2025-12-18.zip'
      UnzipLocation = $DestinationFolder
      Checksum64    = 'd25ad92e4bd0bb7bb51d135da3be799ad37ac1652a0ae449443172f999269169'
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
