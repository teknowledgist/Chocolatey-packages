$ErrorActionPreference = 'Stop'

$packageName= 'ScientificWord'
$url        = 'https://s3-us-west-1.amazonaws.com/download.mackichan.com/sw-6.0.26-windows-installer.exe'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'Scientific Word*'
  checksum      = '4B29020AD0E4A6B95108B25728BDE167F39A519B4ED441BC4E3F85BA149854BD'
  checksumType  = 'sha256'
  silentArgs    = '--mode unattended --unattendedmodeui none'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

