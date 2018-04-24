$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
   url           = 'https://www.crystalidea.com/downloads/speedyfox.zip'
   checksum      = 'd0ebaebc230a15ae27c97b65f44212d0852d862547b0f0ad327b536c7f2037a1'
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
}

Install-ChocolateyZipPackage @packageArgs
