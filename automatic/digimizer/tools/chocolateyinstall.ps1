$ErrorActionPreference = 'Stop'  # stop on all errors

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   url           = 'https://www.digimizer.com/download/digimizersetup.msi'
   checksum      = 'de1feed02c343961a831458018cd405e42db2637f16d79d5f11ba4d37f18354b'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
