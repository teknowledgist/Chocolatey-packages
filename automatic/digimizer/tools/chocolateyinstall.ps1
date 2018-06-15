$ErrorActionPreference = 'Stop'  # stop on all errors

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   url           = 'https://www.digimizer.com/download/digimizersetup.msi'
   checksum      = '50b1a33da7c1af7e348c13b9816102d7ce7a7d7f31dca399dc160b77726390f1'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
