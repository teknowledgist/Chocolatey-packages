$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'redshift-odbc'
   FileType      = 'msi'
   Url64bit      = 'https://s3.amazonaws.com/redshift-downloads/drivers/odbc/2.1.3.0/AmazonRedshiftODBC64-2.1.3.0.msi'
   Checksum64    = 'cfe95373586f22d65ce6168b6cde626614f114861b4fcfb96358f91d5e89a3e7'
   ChecksumType  = "sha256"
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
} 
Install-ChocolateyPackage @params
