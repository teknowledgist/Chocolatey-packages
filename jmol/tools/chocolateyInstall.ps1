$packageName = 'jmol'
$url = 'http://sourceforge.net/projects/jmol/files/latest/download'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Path)

Install-ChocolateyZipPackage $packageName $url $scriptPath

$JavaExe = 'C:\ProgramData\Oracle\Java\javapath\javaw.exe'
$target = (Get-ChildItem $scriptPath -filter jmol.jar -Recurse).fullname
$icon = Join-Path $scriptPath "Jmol_icon13.ico"
$launcher = Join-Path $scriptPath 'Jmol Launcher.exe'
$SG = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $SG -o $launcher -p $JavaExe -c "-jar '$target'" -i $icon --gui

$shortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $launcher -IconLocation $icon
