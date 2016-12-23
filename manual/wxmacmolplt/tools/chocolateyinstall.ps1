$packageName = 'wxMacMolPlt'
$version = '7.7'

$InstallArgs = @{
  packageName = $packageName
  installerType = 'exe'
  url = ""
  url64bit = ''
  checkSum = ''
  checkSum64 = ''
  checkSumType = 'sha256'
  silentArgs = ''
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
