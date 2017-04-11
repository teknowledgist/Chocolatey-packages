$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= 'anti-beacon' 
$url        = 'https://download.spybot.info/AntiBeacon/SpybotAntiBeacon-1.6-setup.exe'
$Checksum   = '9c648ca6a086a0d626b5f4042d51cb78b7641ea380f92f4a9ddbf959fca89c2d'

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
