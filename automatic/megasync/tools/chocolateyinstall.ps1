$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
   checksum       = '23B84C9588A66A7720002FB2AC7622B60784A5052538778CF8F6C9A05D10AC21'
   checksum64     = '25739EC9823C7483811B2C51F8DE4836DBAF5E94EE839555FE13C8076DD0B114'
   checksumType   = 'sha256'
   silentArgs     = '/S /AllUsers'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

