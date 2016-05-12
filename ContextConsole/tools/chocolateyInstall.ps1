$InstallArgs = @{
   packageName = 'contextconsole'
   installerType = 'exe'
   url = 'http://code.kliu.org/cmdopen/downloads/CmdOpenInstall-latest.exe'
   silentArgs = '/quiet'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
