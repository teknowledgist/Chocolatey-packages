$packageName = 'deepview'

$InstallDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName = $packageName
   Url = 'https://spdbv.unil.ch/download/binaries/SPDBV_4.10_PC.zip' 
   UnzipLocation = $InstallDir
   checkSum = '369C0C9B6E058BB67C86DC24D711D6A655E5E023D639FCDA13EC2FE272DE1858'
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallDir 'SPDBV_4.10_PC\spdbv.exe'
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Swiss-PdbViewer.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target

