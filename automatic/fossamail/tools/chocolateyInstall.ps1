$packageName = 'fossamail'
$url32       = 'http://relmirror.fossamail.org/38.1.0//FossaMail-38.1.0.win32.installer.exe'
$checkSum32  = 'a3c3b08ef9a81892da867d9cbdc154dd10f078d25acf37a029c741407d1d3a51'
$url64       = 'http://relmirror.fossamail.org/38.1.0//FossaMail-38.1.0.win64.installer.exe'
$checkSum64  = '063fe2cda53103add5515fb0d715421a1a04f3b25450c30d7274fce67a6529c1'

$InstallArgs = @{
  packageName = $packageName
  installerType = 'exe'
  url = $url32
  url64 = $url64
  checkSum = $checkSum32
  checkSum64 = $checkSum64
  checkSumType = 'sha256'
  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
