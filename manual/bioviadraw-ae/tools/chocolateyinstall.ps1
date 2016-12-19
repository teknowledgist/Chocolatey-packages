$packageName = 'bioviadraw-ae'
$version = '2016'

$InstallArgs = @{
  packageName = $packageName
  installerType = 'exe'
  url = "http://media.accelrys.com/downloads/draw/$version/BIOVIADraw-$($version)_AE.exe"
  checkSum = 'C273F18D64D310ACA0787CACBA3DF5E8E2EBFA506C25B086FD5AC7537BED4AD9'
  checkSumType = 'sha256'
  silentArgs = '/s /v"/qn"'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
