$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Studio 2.0*' 
   fileType      = 'EXE'
   url           = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.9_1/Studio+2.0_32.exe'
   url64bit      = 'https://s3.amazonaws.com/blstudio/Studio2.0/Archive/2.24.9_1/Studio+2.0.exe'
   checksum      = '79195893cb6d8b099d0ceb1da4d2454dc2c02dd7daea151a2e66dce14abe5183'
   checksum64    = '5c9a89d818082bcf3e2f3a4e53c84a8d166aa5ebeeea22c3c5270ace965f9d18'
   checksumType  = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

