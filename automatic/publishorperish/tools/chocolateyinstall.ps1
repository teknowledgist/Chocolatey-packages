$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url           = 'https://harzing.com/download/PoP8Setup.exe'
   checksum      = 'd78d0b0c9215f7d339116f6f7c27ae08cfcdf7a52932008631b6ecb822593bc9'
   checksumType  = 'sha256'
   silentArgs    = "/a /q2 /b0 /log:`"$($env:TEMP)\PublishOrPerish-$($env:chocolateyPackageVersion)-Install.log`""
   validExitCodes= @(0,12)
}

Install-ChocolateyPackage @packageArgs
