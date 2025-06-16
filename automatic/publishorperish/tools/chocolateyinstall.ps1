$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url           = 'https://harzing.com/download/PoP8Setup.exe'
   checksum      = 'db347a07a1d2946f04dd0fdafdd3d7747db6b31131a69ce6c6bac96816cf7698'
   checksumType  = 'sha256'
   silentArgs    = "/a /q2 /b0 /log:`"$($env:TEMP)\PublishOrPerish-$($env:chocolateyPackageVersion)-Install.log`""
   validExitCodes= @(0,12)
}

Install-ChocolateyPackage @packageArgs
