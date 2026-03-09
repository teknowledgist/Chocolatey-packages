$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.2_1/Studio+2.0_32.exe'
   url64bit      = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.2_1/Studio+2.0.exe'
   checksum      = 'd5b19fd07b42024800dfb999e827274a7225c2a6186a8f3754fe1512b909e2fd'
   checksum64    = 'e921b29f9d9f728a3824a6c4220b29173e874cefdce0c7bd0530fe22897a4604'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

