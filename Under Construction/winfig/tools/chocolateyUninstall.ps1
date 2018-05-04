$UninstallArgs = @{
   packageName = 'winfig'
   fileType = 'msi'
   file = 'MsiExec.exe /x{7840AA75-C3C0-4E8C-9102-3598541E04BB}'
   silentArgs = '/quiet'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

