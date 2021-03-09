$ErrorActionPreference = 'Stop'

$url32       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win64.zip'
$checkSum32  = '71249b7b99ae01a6d3eb26da1630f38aafe97d372d0f2d9c41b74442cb689cf8'
$checkSum64  = 'feef8672dd4ef5f8a17bdad68c45bb19205f36e6d98478e3171d88c0d57d22b8'

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
