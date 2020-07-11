$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
   checksum       = '99E667E61E2402117D75A3C90EAAE0A75166AF2FC3E2192EEC2D552130DE6EC3'
   checksum64     = '9EE204D5622281AA9B4CB2CFA9F71C07EE926BC3AAA6C96CC7E952028B9ED27D'
   checksumType   = 'sha256'
   silentArgs     = '/S /AllUsers'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

