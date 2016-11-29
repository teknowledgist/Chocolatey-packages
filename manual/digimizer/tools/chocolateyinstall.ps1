$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName= 'digimizer'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = 'https://www.digimizer.com/download/digimizersetup.msi'
  checksum      = 'F32F093EC3B897E67767FD60E19CEDB52FE6783AD2B72CD3F34D7DE8E7E671A7'
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 