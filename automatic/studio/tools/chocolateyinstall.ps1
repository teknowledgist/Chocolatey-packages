$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.12_1/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.12_1/Studio+2.0.exe'
   checksum      = '4c3b1212472d8986dd76f56142e19dc7692b76b9589f22fb5cd3de12f2d14b6b'
   checksum64    = 'dbe8d26dd61775c675e5e8dc6f464ea93e219da62d932075262889da84bb08fc'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

