$url32      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.12-Windows-32bit.exe'
$url64      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.12-Windows-64bit.exe'
$checkSum32 = 'ec96eb0ecf58761116f7b960dad801eeb20238157c3cd9dd0b3cdb43820e34c7'
$checkSum64 = 'b3535c12a4c9dcacb24fa20dbcf4546eeeb4de419169a792e32588b4f67d7cbd'

$InstallArgs = @{
   packageName    = 'geoda'
   installerType  = 'exe'
   url            = $url32
   url64bit       = $url64
   checkSum       = $checkSum32
   checkSum64     = $checkSum64
   checkSumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

