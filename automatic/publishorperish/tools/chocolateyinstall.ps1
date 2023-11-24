$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url           = 'https://harzing.com/download/PoP8Setup.exe'
   checksum      = '439376954e942602a4045c50d9da6bafb73611d5598a53acf8c6fef2ca6f9323'
   checksumType  = 'sha256'
   silentArgs    = "/a /q2 /b0 /log:`"$($env:TEMP)\PublishOrPerish-$($env:chocolateyPackageVersion)-Install.log`""
   validExitCodes= @(0,12)
}

Install-ChocolateyPackage @packageArgs
