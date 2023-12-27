$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.23.12_1/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.23.12_1/Studio+2.0.exe'
   checksum      = '562c6a27cb81ca89b68b34a4aa1df731b00b3e7164c45cce132e6c2e91375392'
   checksum64    = '15e3033f9de579c326b4f4c653a2f1c0a1586b3d4a8eff8512f5e2c4c3564288'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

