$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
#   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
#   checksum       = '963a82b9b767f77dfa9edf9864590a0eb813ddb677b72705717ca79b18b8b6a7'
   checksum64     = '03928a043476ae9c5fe2f4e205bf9ad251449e0d6202435085e8f1ed9d76557d'
   checksumType   = 'sha256'
   silentArgs     = '/S /MULTIUSER=true'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

