$url32      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.8.16-Windows-32bit.exe'
$url64      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.8.16-Windows-64bit.exe'
$checkSum32 = '49dab1aad9d7d0756882b5e4456b7c9aa3fb1304fb141e19dfda28c43c2acad0'
$checkSum64 = 'd35e485272ef3bc30d9e00fe295555626a3302302426662252581420507e80db'

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

