$packageName = 'Olex2'
$version     = '1.2.8'
$url32       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
$checkSum32  = 'a32bb6a09313595d9be679e9e2806d9cfe890ab7c1930d78cde3af96246ea6ce'
$checkSum64  = '34afd7bd0d192d78f0a917ede4bc51f638eddc36ff50b1b256773fb902339062'

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
