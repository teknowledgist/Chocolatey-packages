$UninstallArgs = @{
   packageName = 'fragstats'
   fileType = 'exe'
   file = "C:\Program Files (x86)\Fragstats 4\unins000.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs





