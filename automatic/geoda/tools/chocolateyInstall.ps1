$url32      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.10-Windows-32bit.exe'
$url64      = 'https://s3-us-west-2.amazonaws.com/geodasoftware/GeoDa-1.10-Windows-64bit.exe'
$checkSum32 = '4fadbb0a9752a9e2df0c6f8af1bc1aabc2ae4ec843e14cac8206f692ef4fa1cf'
$checkSum64 = '59afe5dae61e0ae20e81c9b5d00e4eff0e7d45783bb02978f971e8097b87da56'

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

