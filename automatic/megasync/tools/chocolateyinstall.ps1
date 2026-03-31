$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
#   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
#   checksum       = '963a82b9b767f77dfa9edf9864590a0eb813ddb677b72705717ca79b18b8b6a7'
   checksum64     = '477727feb43dda716a40a280c6e962223fcd92d7f85b9b1b276d24e3112b7d3b'
   checksumType   = 'sha256'
   silentArgs     = '/S /MULTIUSER=true'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

