$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$env:ChocolateyPackageFolder\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = '7d33dbc5ab0e4a9e1c88471d8afcba024dc62792f643833869f4e459306b01e6'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
