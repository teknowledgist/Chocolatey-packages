$packageName = 'Jmol'

$url        = 'https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.8/Jmol%2014.8.0/Jmol-14.8.0-binary.zip'
$Checksum   = '79058f234766cbb6e9471e450d9da76f11a16560de6dfcf0ef30930360b6ec5b'
$installDir = Split-Path -parent $script:MyInvocation.MyCommand.Path

$installArgs = @{
   packageName   = $packageName
   url           = $url
   Checksum      = $Checksum
   ChecksumType  = 'sha256'
   UnzipLocation = $installDir
}

Install-ChocolateyZipPackage @installArgs

$JavaExe = "$env:ProgramData\Oracle\Java\javapath\javaw.exe"
$target = (Get-ChildItem $installDir -filter jmol.jar -Recurse).fullname
$icon = Join-Path $installDir 'tools\Jmol_icon13.ico'
$launcher = Join-Path $installDir 'Jmol Launcher.exe'
$SGpath = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $SGpath -o $launcher -p $JavaExe -c "-jar '$target'" -i $icon --gui

$shortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $launcher -IconLocation $icon
