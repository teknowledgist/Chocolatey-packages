$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName= 'digimizer'

$packageArgs = @{
   packageName   = $packageName
   fileType      = 'msi'
   url           = 'http://www.digimizer.com/download/digimizersetup.msi'
   checksum      = '6d52b303a24aaf2f0bf88a0210e2b56437e2e75ba6a2af664fa9e46626694164'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
