$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
#   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
#   checksum       = '963a82b9b767f77dfa9edf9864590a0eb813ddb677b72705717ca79b18b8b6a7'
   checksum64     = 'ae5a6ab91533b900c04517249feee1a8e3dc268e96812258dbd51cb80953843a'
   checksumType   = 'sha256'
   silentArgs     = '/S /MULTIUSER=true'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

