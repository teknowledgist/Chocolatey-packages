$InstallArgs = @{
   PackageName = 'crystalexplorer'
   Url = 'http://crystalexplorer.scb.uwa.edu.au/downloads/CrystalExplorer3.1_Windows-Intel-32bit.zip' 
   UnzipLocation = ${env:ProgramFiles(x86)}
}
Install-ChocolateyZipPackage @InstallArgs

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'CrystalExplorer.lnk'
$target = (Get-ChildItem (join-path ${env:ProgramFiles(x86)} 'CrystalExplorer*') -include cry*.exe -Recurse).fullname

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
