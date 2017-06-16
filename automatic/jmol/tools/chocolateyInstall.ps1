$packageName = 'Jmol'

$url        = 'https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.18/Jmol%2014.18.1/Jmol-14.18.1-binary.zip'
$Checksum   = '93a5b12b0e694274a16fc12d7a2f23bbbdec860c1316da0cace56df6a42fb3b2'
$installDir = Split-Path (Split-Path -parent $script:MyInvocation.MyCommand.Path)

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
