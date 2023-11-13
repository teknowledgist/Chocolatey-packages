$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$FolderOfPackage\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = '8e56a5c84999f036355759e5cb759e3055df761b55d9ae6a72825d4199f328e9'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
