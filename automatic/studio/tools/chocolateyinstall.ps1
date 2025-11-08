$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.25.10_5/Studio+2.0_32.exe'
   url64bit      = 'https://studio.download.bricklink.info/Studio2.0/Archive/2.25.10_5/Studio+2.0.exe'
   checksum      = 'f9545f9cbaeffa8c0d861b3f731b03d1bc90db11c2cf68016cdf8ef033630e74'
   checksum64    = 'a3909d4d69b5db892023fe06fcdbe126b72edce486edc0078068f720bb314185'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

