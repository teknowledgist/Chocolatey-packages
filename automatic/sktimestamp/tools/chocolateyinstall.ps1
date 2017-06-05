$ErrorActionPreference = 'Stop'

$packageName= 'sktimestamp'
$url        = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/SKTimeStamp-1.3.5.msi/download' 
$url64      = 'https://sourceforge.net/projects/stefanstools/files/SKTimeStamp/SKTimeStamp64-1.3.5.msi/download' 
$Checksum   = 'c5db0d44548dfa40ea9be5dc0e4163482cd8390d1dafe099d5596fa09eef2f20'
$Checksum64 = '64db45f107181347ea93173f291d09013f2f19e274ba9e6da1d4f183686985f8'

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
