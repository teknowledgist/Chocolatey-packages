$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'AVSnap*' 
   fileType      = 'EXE'
   url           = 'https://www.avsnap.com/software/AVSnap_Setup.exe'
   checksum      = '8b32184ea091098e381133c64768f1d294dd8cc4454e0ef71e29a6031bdacfb6'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}
Install-ChocolateyPackage @packageArgs

