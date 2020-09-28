$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
   checksum       = '2650b19a0dc5ea8eaae71c07e63e5540a2b567c6412933e467a8a25a7f17f4b0'
   checksum64     = 'c50dd85fe3aabdb0d3ad68bd71fc1b3b67df3ada991a3126aef47a65f1b85ee9'
   checksumType   = 'sha256'
   silentArgs     = '/S /AllUsers'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

