$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Studio+2.0.exe'
   checksum      = '3725ebbf704c8cd6cc87ffb335f90143b206daad5c748ea0b675c5605791bd08'
   checksum64    = '8073562130eccb8022f8efd6e0deb8a39760a60d26117f9e4c0189eaa3b5cb0d'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

