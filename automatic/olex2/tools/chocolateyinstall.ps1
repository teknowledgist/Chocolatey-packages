$packageName = 'Olex2'
$version     = '1.2.8'
$url32       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
$checkSum32  = 'a8439b51381d53325c02615e4c47a596336180b946be68f6a5217f504d4090c3'
$checkSum64  = '84c4f629ec68a7f64bb9453e3c1e0485f4f82ec7e76da9773ac0f3108d7e70b1'

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
