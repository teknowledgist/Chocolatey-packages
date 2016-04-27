$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

$InstallArgs = @{
   PackageName = 'deepview'
   Url = 'http://spdbv.vital-it.ch/download/binaries/SPDBV_4.10_PC.zip' 
   UnzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallArgs.UnzipLocation 'SPDBV_4.10_PC\spdbv.exe'
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Swiss-PdbViewer.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target

