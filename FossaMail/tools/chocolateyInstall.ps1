$InstallArgs = @{
  packageName = 'fossamail'
  installerType = 'exe'
  url = 'http://relmirror.fossamail.org/25.2.1/FossaMail-25.2.1.win32.installer.exe'
  url64 = 'http://relmirror.fossamail.org/25.2.1/FossaMail-25.2.1.win64.installer.exe'
  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
