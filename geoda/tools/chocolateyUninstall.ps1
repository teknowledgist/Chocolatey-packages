$UninstallArgs = @{
   packageName = 'geoda'
   fileType = 'exe'
   file = "C:\Program Files\GeoDa Software\unins000.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs
