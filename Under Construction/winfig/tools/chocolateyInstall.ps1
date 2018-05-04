$InstallArgs = @{
   packageName = 'winfig'
   installerType = 'msi'
   url = "http://www.winfig.com/WinFIG-Dateien/WinFIG60final.msi"
   silentArgs = '/quiet /norestart'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
