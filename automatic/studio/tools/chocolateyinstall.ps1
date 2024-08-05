$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.6_2/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.6_2/Studio+2.0.exe'
   checksum      = '38127eaf83ddba600d4828ccd4b7d46b03422564b7335bd10fdfe87ef8fe5ff9'
   checksum64    = '279ada6f7cfa454dcb45148be40842ab725a9a0d6d4375294e3139abfb7f947c'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

