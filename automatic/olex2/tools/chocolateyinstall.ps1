$packageName = 'Olex2'
$version     = '1.2.8'
$url32       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
$checkSum32  = 'c2c083399e66dbb051f18ac4ddc90f4acdae27cc923ca6df56358147546c04dd'
$checkSum64  = '8e02debc3ed7d956e88c0fc969b96fd7570fba490d02a6288b2fa6201c83a709'

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
