$ErrorActionPreference = 'Stop'

$packageName= 'sktimestamp'
$url        = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/SKTimeStamp-1.3.7.msi/download' 
$url64      = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/SKTimeStamp64-1.3.7.msi/download' 
$Checksum   = '72443a2ba6186ceb23eb6ef947a64f8a8d8587ec0cb74398f09f43b7f7d19ece'
$Checksum64 = '80b1c79122d22c8720674171e9db47e10b7ea331450fd6af2aca0391ae18c5c5'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'SKTimeStamp*'
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  checksum      = $Checksum
  checksum64    = $Checksum64
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
