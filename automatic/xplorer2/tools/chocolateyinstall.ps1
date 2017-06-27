$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url         = ''
$Checksum    = ''

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url
  softwareName   = 'xplorer² lite*'
  checksum       = ''
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}


Install-ChocolateyPackage @packageArgs 