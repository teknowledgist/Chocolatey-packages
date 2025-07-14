$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.25.6_1/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.25.6_1/Studio+2.0.exe'
   checksum      = '4c03bdcee0ea7146ff2b80ba0c635d109ddabb5653420621f6bcc758197d895a'
   checksum64    = '02273d62c9b89c727f40c9625b724e3d33670a945ecac3e9197601f01fe9974a'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

