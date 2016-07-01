$InstallArgs = @{
   packageName = 'gwr4'
   installerType = 'exe'
   url = 'http://geodacenter.org/downloads/unprotected/GWR408_setup_win32.exe'
   url64bit = 'http://geodacenter.org/downloads/unprotected/GWR408_setup_win64.exe'
   silentArgs = '/s /a /s /v"/quiet"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

