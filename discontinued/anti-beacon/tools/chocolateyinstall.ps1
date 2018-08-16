$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'anti-beacon' 
$url        = 'https://download.spybot.info/AntiBeacon/SpybotAntiBeacon-2.1-setup.exe'
$Checksum   = '5ae1cfd967a21399a21b33953fa254c61740c14d844f7a5091986204b8d1e6c2'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE'
  url           = $url
  checksum      = $Checksum
  checksumType  = 'sha256'
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' 
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs
