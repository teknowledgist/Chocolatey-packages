$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  file          = "$env:ProgramFiles\Q-Dir\Q-Dir.exe"
  softwareName  = 'Q-Dir*'
  fileType      = 'EXE'
  silentArgs    = '-uninstall'
  validExitCodes= @(0,1)
}
Uninstall-ChocolateyPackage @packageArgs

Uninstall-BinFile 'qdir'
