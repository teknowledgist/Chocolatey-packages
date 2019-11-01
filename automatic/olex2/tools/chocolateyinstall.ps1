$ErrorActionPreference = 'Stop'

$url32       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win32.zip'
$url64       = 'http://www.olex2.org/olex2-distro/1.3/olex2-win64.zip'
$checkSum32  = '47d7ba2ecf5eef54f06af994def8de344194fe609c7155f0afa64f85f2b9a0b1'
$checkSum64  = '57efed2e0e890c834d1b0fd1fac97e656225cd1841a4d08d0d7ee6f9979d38b7'

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
