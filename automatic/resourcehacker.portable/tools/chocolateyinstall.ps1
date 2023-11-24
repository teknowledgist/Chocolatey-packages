$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$FolderOfPackage\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = 'f958db1d239e69051145777de9943b267a3230cc3d140599b48cf024e2c8b3a2'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
