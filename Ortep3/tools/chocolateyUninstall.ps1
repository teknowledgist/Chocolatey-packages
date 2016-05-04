$UninstallArgs = @{
   packageName = 'ortep3'
   fileType = 'exe'
   file = 'C:\Program Files (x86)\Ortep3\unins000.exe'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

# remove the environment variable
Install-ChocolateyEnvironmentVariable 'ORTEP3DIR' $null 'Machine'
