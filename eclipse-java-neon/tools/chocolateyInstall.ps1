$PackageName = 'eclipse-java-neon'

$InstallArgs = @{
   PackageName = $PackageName
   Url = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32.zip&r=1'
   Url64 = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/R/eclipse-java-neon-R-win32-x86_64.zip&r=1'
   Checksum = '536a6d47b9fa01b6adb1831d41a7471aa84debefaa1fb2ea699dff9cfed6f0a8'
   Checksum64 = 'a3c6e7e9332497f5154486bf8481f683b16ee33f3696142bbaeb1a78277d79cb'
   ChecksumType = 'sha256'
   UnzipLocation = Join-Path $env:ProgramData $PackageName
}
Install-ChocolateyZipPackage @InstallArgs

$UnzipLog = Get-ChildItem $env:chocolateyPackageFolder -Filter "*.zip.txt"
$InstallFolder = Get-Content $UnzipLog.FullName | Select-Object -First 1
$target = (Get-ChildItem $InstallFolder -include eclipse.exe -Recurse).fullname

# include shortcut on desktop for current user
$desktop = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Eclipse Java IDE (Neon).lnk'
Install-ChocolateyShortcut -ShortcutFilePath $desktop -TargetPath $target

# include shortcut in all user's start menu (for discoverability)
$startmenu = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Eclipse Java IDE (Neon).lnk'
Install-ChocolateyShortcut -ShortcutFilePath $startmenu -TargetPath $target

<#
Temporary Notes:
http://www.eclemma.org/installation.html
https://www.eclipse.org/downloads/packages/release/Neon
https://github.com/trajano/choco-packages/blob/master/eclipse/tools/chocolateyinstall.ps1
https://github.com/trajano/choco-packages/blob/master/eclipse-eclemma/tools/chocolateyinstall.ps1
https://www.apreltech.com/Free/How_to_run_as_system_user
#>
