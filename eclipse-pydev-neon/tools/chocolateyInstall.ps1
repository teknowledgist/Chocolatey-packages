$EclipseInstallArgs = @{
   PackageName = 'eclipse-neon'
   Url = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32.zip&r=1'
   Url64 = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32-x86_64.zip&r=1'
   UnzipLocation = Split-path (Split-Path -parent $MyInvocation.MyCommand.Definition)
}
Install-ChocolateyZipPackage @EclipseInstallArgs

$PyDevInstallArgs = @{
   PackageName = 'pydev'
   Url = 'https://sourceforge.net/projects/pydev/files/latest/download'
   UnzipLocation = (Get-ChildItem $EclipseInstallArgs.UnzipLocation -filter dropins -Recurse).fullname
}
Install-ChocolateyZipPackage @PyDevInstallArgs


$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'PyDev IDE (Neon).lnk'
$target = (Get-ChildItem $EclipseInstallArgs.UnzipLocation -include eclipse.exe -Recurse).fullname

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
