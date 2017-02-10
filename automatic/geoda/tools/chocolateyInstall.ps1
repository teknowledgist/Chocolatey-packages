$url32      = "https://s3.amazonaws.com/geoda/software/GeoDa-1.8.14-Windows-32bit.exe"
$url64      = "https://s3.amazonaws.com/geoda/software/GeoDa-1.8.14-Windows-64bit.exe"
$checkSum32 = '646F8422821B694152D85665DB10765B62051A028962F235CE11311363E59F36'
$checkSum64 = '06588FC1871C8D0D96CC0D1F2B64C4B78B8417F9C4136FCF02664852240F9273'

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

