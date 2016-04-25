$InstallArgs = @{
   packageName = 'geoda'
   installerType = 'exe'
   url = 'https://geodacenter.org/downloads/unprotected/GeoDa-1.6.7-Windows-32bit.exe'
   url64bit = 'https://geodacenter.org/downloads/unprotected/GeoDa-1.6.7-Windows-64bit.exe'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

