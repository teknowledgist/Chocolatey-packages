$PackageName = 'pydev'
$Url = 'https://sourceforge.net/projects/pydev/files/latest/download'

$HostPackage = 'eclipse-java-neon'
$HostPackageLocation = "$env:ChocolateyInstall\lib\$HostPackage"
$HostUnzipLog = Get-ChildItem $HostPackageLocation -Filter "$HostPackage*.zip.txt" 
$HostInstallLocation = Get-Content $HostUnzipLog | Select-Object -First 1

$UnzipLocation = (Get-ChildItem $HostInstallLocation -filter dropins -Recurse).fullname

Install-ChocolateyZipPackage @PyDevInstallArgs


$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'PyDev IDE (Neon).lnk'
$target = (Get-ChildItem $HostInstallLocation -include eclipse.exe -Recurse).fullname

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
