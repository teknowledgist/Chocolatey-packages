$packageName = 'fossamail'
$url32       = 'http://relmirror.fossamail.org/27.0.0//FossaMail-27.0.0.win32.installer.exe'
$checkSum32  = 'ff10bc720b4228f985f30b86ad8fb56ca8901bbc3df93e989883b7c39ce17f6b'
$url64       = 'http://relmirror.fossamail.org/27.0.0//FossaMail-27.0.0.win64.installer.exe'
$checkSum64  = '152965c01ad0bf9ac283b34d83151d3b1fdf8de3a76e4978727261146c21f0ce'

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
