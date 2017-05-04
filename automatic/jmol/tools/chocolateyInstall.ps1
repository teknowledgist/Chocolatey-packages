$packageName = 'Jmol'

$url        = 'https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.15/Jmol%2014.15.2/Jmol-14.15.2-binary.zip'
$Checksum   = '23f2dca6e9572e67b75f6e138e3d24ae6b726d245da0359ea2989af9f136eeb9'
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
