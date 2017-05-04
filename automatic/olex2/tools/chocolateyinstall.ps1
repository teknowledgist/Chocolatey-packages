$packageName = 'Olex2'
$version     = '1.2.8'
$url32       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
$checkSum32  = 'd3eeef20b2abe35c691606b2b81e5efa8febf7818526926f162ec78e36a196c4'
$checkSum64  = '2b3a2887fa577b2d86cf218a04c20bf1f2cd178d9f79cd481d6b3fbd64aa5554'

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
