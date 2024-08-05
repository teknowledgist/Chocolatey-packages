$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url           = 'https://harzing.com/download/PoP8Setup.exe'
   checksum      = '6a39d1935748275b7d4c3e8f88e14e5cad5d3192972e71c8cb6957386bbf586e'
   checksumType  = 'sha256'
   silentArgs    = "/a /q2 /b0 /log:`"$($env:TEMP)\PublishOrPerish-$($env:chocolateyPackageVersion)-Install.log`""
   validExitCodes= @(0,12)
}

Install-ChocolateyPackage @packageArgs
