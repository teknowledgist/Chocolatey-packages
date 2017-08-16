$packageName = 'Olex2'
$version     = '1.2.8'
$url32       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
$checkSum32  = '7cb9a666204793b6264e7346ed8658415f242c2dc253ebba70d219573b52570b'
$checkSum64  = 'bbea161477a1fece55b72db6a0c20eaa9e4bb2a85415705e307845923cf77965'

$InstallDir = Join-Path $env:ProgramData $packageName

$InstallArgs = @{
   PackageName   = $packageName
   Url           = $url32
   Url64         = $url64
   UnzipLocation = $InstallDir
   checkSum      = $checkSum32
   checkSum64    = $checkSum64
   checkSumType  = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallDir 'olex2.exe'
$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Olex2-1.2.lnk'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Olex2-1.2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target
