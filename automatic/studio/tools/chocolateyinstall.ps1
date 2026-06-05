$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.5_1/Studio+2.0_32.exe'
   url64bit      = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.26.5_1/Studio+2.0.exe'
   checksum      = '4d709598373d1f05380406175df73c3ffaea0fe6252397c98bb27580b214e360'
   checksum64    = '74e7dc32dd1763bf1f835854232380f75f6f3d72de4177d49b8ff12bc2ce4788'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

