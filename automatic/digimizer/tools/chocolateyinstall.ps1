$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName= 'digimizer'

$packageArgs = @{
   packageName   = $packageName
   fileType      = 'msi'
   url           = 'http://www.digimizer.com/download/digimizersetup.msi'
   checksum      = 'f32f093ec3b897e67767fd60e19cedb52fe6783ad2b72cd3f34d7de8e7e671a7'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
