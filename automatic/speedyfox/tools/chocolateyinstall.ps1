$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
   url           = 'https://www.crystalidea.com/downloads/speedyfox.zip'
   checksum      = 'b9bf840d66be1e481bef922b51d0c308f174216e361b9f8144cc584e7e40f224'
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
}

Install-ChocolateyZipPackage @packageArgs
