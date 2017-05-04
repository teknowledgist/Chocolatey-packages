$InstallArgs = @{
  packageName    = 'fossamail'
  installerType  = 'exe'
  url            = 'https://github.com/teknowledgist/Chocolatey-packages/releases/download/v1.0/FossaMail-38.2.0.win32.installer.exe'
  url64          = 'https://github.com/teknowledgist/Chocolatey-packages/releases/download/v1.0/FossaMail-38.2.0.win64.installer.exe'
  checkSum       = 'E080C6877C82193CCF1CABD55AD1D7D5EF8470C5D2BC1E98C6CEA27674F8E50F'
  checkSum64     = 'EE855950394519D77C5834CCA8EFD69373AF9228F697AACAEAA5D9CE4010074A'
  checkSumType   = 'sha256'
  silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
