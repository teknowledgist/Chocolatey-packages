$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'DNGConverter*'
   fileType       = 'EXE'
   url64bit       = 'ftp://ftp.adobe.com/pub/adobe/dng/win/DNGConverter_13_1.exe'
   checksum64     = '6472582bbf4d2026fb971c202c9551d001a245c6273add423fcda064b424902e'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
