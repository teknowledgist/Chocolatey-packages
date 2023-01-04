$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'transwiz'
   FileType      = 'msi'
   Url           = 'https://www.forensit.com/Downloads/Transwiz.msi'
   Checksum      = '511c2c0908883bc9d05295e5145b767f2633461c93a31d1cb8d765ee09cdd801'
   ChecksumType  = "sha256"
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
} 
Install-ChocolateyPackage @params
