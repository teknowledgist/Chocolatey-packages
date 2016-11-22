$version = '1.8.14'

$InstallArgs = @{
   packageName = 'geoda'
   installerType = 'exe'
   url = "https://s3.amazonaws.com/geoda/software/GeoDa-$version-Windows-32bit.exe"
   url64bit = "https://s3.amazonaws.com/geoda/software/GeoDa-$version-Windows-64bit.exe"
   checkSum = '646F8422821B694152D85665DB10765B62051A028962F235CE11311363E59F36'
   checkSum64 = '06588FC1871C8D0D96CC0D1F2B64C4B78B8417F9C4136FCF02664852240F9273'
   checkSumType = 'sha256'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

