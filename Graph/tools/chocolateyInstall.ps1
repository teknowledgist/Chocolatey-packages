$InstallArgs = @{
   packageName = 'graph'
   installerType = 'exe'
   url = "https://www.padowan.dk/bin/SetupGraph-4.4.2.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

