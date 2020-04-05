$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
   url           = 'https://www.crystalidea.com/downloads/speedyfox.zip'
   checksum      = 'aee4ce9a7439676f511aa0997c6e96a0ebdd1bccbea1ca97dc864eeadfebfab0'
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
}

Install-ChocolateyZipPackage @packageArgs
