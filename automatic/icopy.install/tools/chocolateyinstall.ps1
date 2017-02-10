$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'icopy.install'
$url        = 'https://sourceforge.net/projects/icopy/files/iCopy/1.6.3/iCopy1.6.3setup.exe'

$packageArgs = @{
   packageName    = $packageName
   fileType       = 'EXE'
   url            = $url
   checksum       = 'ae8a5ad0f3209b8ed2d64fb0e4efaa7e38c70d78112265d4664911d129b79f71'
   checksumType   = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
