$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'AVSnap*' 
   fileType      = 'EXE'
   url           = 'https://www.avsnap.com/software/AVSnap_Setup.exe'
   checksum      = '8a8da1493ccb312181278112ec091b4797efa0b974fdc84d299c9e4172ce0eec'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}
Install-ChocolateyPackage @packageArgs

