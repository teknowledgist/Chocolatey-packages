$UninstallArgs = @{
   packageName = 'ccdcmercury'
   fileType = 'exe'
   file = "C:\Program Files (x86)\CCDC\Mercury 3.8\uninstall.exe"
   silentArgs = '--mode unattended'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs





