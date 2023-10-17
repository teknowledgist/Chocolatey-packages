$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$FolderOfPackage\v$env:ChocolateyPackageVersion"
   url           = 'http://www.angusj.com/resourcehacker/resource_hacker.zip'
   checksum      = '0b3203a2a866a7d1957f2bce8c2346a1dcd8b02c86c895fbc295d89c34dccba6'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
