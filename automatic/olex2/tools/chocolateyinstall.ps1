$ErrorActionPreference = 'Stop'

$url32       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win64.zip'
$checkSum32  = 'cf96c4ec7d2b3a837526a6ce30a186c84260e9cd3f671b23c2303e449b642101'
$checkSum64  = 'f393ca5472f6d71e1a540d854ada6ce4d3f242545762a1e3e15bf830925003d5'

$DisplayedVersion = $env:ChocolateyPackageVersion.split('.')[0-1] -join '.'

$pp = Get-PackageParameters
if ($pp['INSTALLDIR']) { 
   Write-Host 'You have opted to install to an alternate location.' -ForegroundColor Cyan
   if (Test-Path $pp['INSTALLDIR']) {
      $InstallDir = Join-Path $pp['INSTALLDIR'] "$env:ChocolateyPackageName-$DisplayedVersion"
   } else { Throw "Path '$($pp['INSTALLDIR'])' does not exist!" }
} else {
   $InstallDir = Join-Path $env:ProgramData "$env:ChocolateyPackageName-$DisplayedVersion"
}

$InstallArgs = @{
   PackageName   = $env:ChocolateyPackageName
   Url           = $url32
   Url64         = $url64
   UnzipLocation = $InstallDir
   checkSum      = $checkSum32
   checkSum64    = $checkSum64
   checkSumType  = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$ShortcutName = "Olex2-$DisplayedVersion.lnk"
$targetPath = (Get-ChildItem $InstallDir -filter "$env:ChocolateyPackageName.exe").fullname
$DeskShortcut = Join-Path "$env:PUBLIC\Desktop" $ShortcutName
$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$ShortcutName"

Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $targetPath

if ($pp['Icon']) { 
   Write-Host 'You have opted for the Desktop Icon.' -ForegroundColor Cyan
   Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $targetPath
}
