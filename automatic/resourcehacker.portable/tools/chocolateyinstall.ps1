$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$FolderOfPackage\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = '52f81ee4778070d6aa72d8719a1a68fea2f288005deb02667542754f747776f8'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
