$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.25.8_1/Studio+2.0_32.exe'
   url64bit      = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.25.8_1/Studio+2.0.exe'
   checksum      = '54e664ff4ad61bd20e0a7ba772c9e86f37f43e36d1a6099cf34baeb33d595fb7'
   checksum64    = '0b9a9e5c87976e270da6cd8712a00972ff416380da01ed5f8284d25f2c92dc1f'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

