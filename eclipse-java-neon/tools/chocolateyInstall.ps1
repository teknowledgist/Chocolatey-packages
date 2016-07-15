$InstallArgs = @{
   PackageName = 'eclipse-java-neon'
   Url = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32.zip&r=1'
   Url64 = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32-x86_64.zip&r=1'
   UnzipLocation = Split-path (Split-Path -parent $MyInvocation.MyCommand.Definition)
}
Install-ChocolateyZipPackage @InstallArgs

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'Eclipse IDE (Neon).lnk'
$target = (Get-ChildItem $InstallArgs.UnzipLocation -include eclipse.exe -Recurse).fullname

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
