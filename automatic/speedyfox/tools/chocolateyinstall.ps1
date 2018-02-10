$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
   url           = 'https://www.crystalidea.com/downloads/speedyfox.zip'
   checksum      = 'c0345ef131a07d1cea157ac55ae11a9261352c428ea4c419f4e17fc6655c000b'
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
}

Install-ChocolateyZipPackage @packageArgs
