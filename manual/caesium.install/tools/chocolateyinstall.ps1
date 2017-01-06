$installArgs = @{
   packageName = 'Caesium.install'
   installerType = 'exe'
   url = 'https://sourceforge.net/projects/caesium/files/1.7.0/caesium-1.7.0-win.exe/download'
   checkSum = '1C7CE7B925391730A2B7DBAB52DF7AC2F78D45580A423BC6B299F2E74A4B1C59'
   checkSumType = 'sha256'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @installArgs
