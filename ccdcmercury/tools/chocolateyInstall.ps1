$InstallArgs = @{
   packageName = 'ccdcmercury'
   installerType = 'exe'
   url = 'https://downloads.ccdc.cam.ac.uk/Mercury/3.8/mercurystandalone-3.8-windows-installer.exe'
   silentArgs = '--mode unattended --prefix "C:\Program Files (x86)\CCDC\Mercury 3.8"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

