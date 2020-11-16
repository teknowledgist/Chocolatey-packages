$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$env:ChocolateyPackageFolder\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = 'c5a0e7f4b8f1089418520562c13d45f8e6fcfff65537830fb166f218b095708c'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
