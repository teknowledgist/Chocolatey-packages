$InstallArgs = @{
   packageName = 'contextconsole'
   installerType = 'exe'
   url = 'http://code.kliu.org/cmdopen/downloads/CmdOpenInstall-latest.exe'
   checkSum = '108D24832359AE8E34A2E661DEA3F5F468DCA7D5074C417EBA33227D552A07BA'
   checkSumType 'sha256'
   silentArgs = '/quiet'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
