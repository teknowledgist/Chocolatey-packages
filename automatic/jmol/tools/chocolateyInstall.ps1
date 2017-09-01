$packageName = 'Jmol'

$url        = 'https://sourceforge.net/projects/jmol/files/Jmol/Version%2014.20/Jmol%2014.20.5/Jmol-14.20.5-binary.zip'
$Checksum   = 'b106616471692421eb7817099d17654f8f55eec0251ca037d7d5aed424e9a07b'
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
