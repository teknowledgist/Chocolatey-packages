$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.3_1/Studio+2.0_32.exe'
   url64bit      = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.3_1/Studio+2.0.exe'
   checksum      = '74602da392214d7afa0569102d54fb6b687d119a3135c6ae1864048aaf807bf5'
   checksum64    = 'f81e990910d09888b1710ebcf8264cae2a6327850aa21aac1d357bed48a51eb5'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

