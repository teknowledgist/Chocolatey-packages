$url32      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.10-Windows-32bit.exe'
$url64      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.10-Windows-64bit.exe'
$checkSum32 = '2f5b71e8df1b546c75d3eaeba6714a32410ee65b722e0ad11862b69e0f239fc3'
$checkSum64 = 'cd9918394112da41070ee7dc1f93309ab5dbcd7d66508075cae93c3f2ba63a4b'

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

