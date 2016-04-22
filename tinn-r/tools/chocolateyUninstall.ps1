$UninstallArgs = @{
   packageName = 'tinn-r'
   fileType = 'exe'
   file = "C:\Program Files\Tinn-R\unins000.exe"
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

