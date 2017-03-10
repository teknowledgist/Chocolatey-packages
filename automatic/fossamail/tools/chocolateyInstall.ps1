$packageName = 'fossamail'
$url32       = 'http://relmirror.fossamail.org/38.0.0//FossaMail-38.0.0.win32.installer.exe'
$checkSum32  = '5f2acf5ac0847b6eacd9a8b14cfe247f97912d9f4a86a76216e4f0a6d40996e4'
$url64       = 'http://relmirror.fossamail.org/38.0.0//FossaMail-38.0.0.win64.installer.exe'
$checkSum64  = 'cd45dacef2f9b3d077b4c3ad1916b6ed86694979104ed13d078fde7c6e504f6c'

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
