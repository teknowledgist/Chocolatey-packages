$InstallArgs = @{
   packageName = 'encifer'
   installerType = 'exe'
   url = 'https://downloads.ccdc.cam.ac.uk/enCIFer/1.5/encifer-1.5.1-windows-installer.exe'
   silentArgs = '--mode unattended --prefix "C:\Program Files (x86)\CCDC\enCIFer 1.5.1"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

