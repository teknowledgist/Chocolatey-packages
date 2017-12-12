$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-Path -parent $MyInvocation.MyCommand.Definition
   url           = 'https://www.crystalidea.com/downloads/speedyfox.zip'
   checksum      = '9d662bb237feca9cda2a35161e6829c2d68301a7a345cb3af1cf3d6538a572c9'
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
}

Install-ChocolateyZipPackage @packageArgs
