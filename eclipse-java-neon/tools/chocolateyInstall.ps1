$InstallArgs = @{
   PackageName = 'eclipse-java-neon'
   Url = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32.zip&r=1'
   Url64 = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32-x86_64.zip&r=1'
   Checksum = '78919c417386ce0a5df27eba542e07f62c2331ef'
   Checksum64 = '3330a534b40c28a189da328130a29561795250e0'
   ChecksumType = 'sha1'
   UnzipLocation = $env:ProgramData
}
Install-ChocolateyZipPackage @InstallArgs

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'Eclipse Java IDE (Neon).lnk'
$target = (Get-ChildItem $InstallArgs.UnzipLocation -include eclipse.exe -Recurse).fullname

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
