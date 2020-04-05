$ErrorActionPreference = 'Stop'  # stop on all errors

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   url           = 'https://www.digimizer.com/download/digimizersetup.msi'
   checksum      = '177f82e9774721a5ea805ee4d1e7340e857dbc074828f1d239128367738c13f5'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
