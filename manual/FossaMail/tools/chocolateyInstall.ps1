$packageName = 'fossamail'
$version = '25.2.4'

$InstallArgs = @{
  packageName = $packageName
  installerType = 'exe'
  url = "http://relmirror.fossamail.org/$version/FossaMail-$version.win32.installer.exe"
  url64 = "http://relmirror.fossamail.org/$version/FossaMail-$version.win64.installer.exe"
  checkSum = '68211DACC0E5401E33EB20558BD6319BC39ADD31DBA57F8F1C62F687BC827ADF'
  checkSum64 = '537C479EA95613D7AB232F5D99ADE2D97873C4F28A9E0F344DBE278F4F21F2A1'
  checkSumType = 'sha256'
  silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
