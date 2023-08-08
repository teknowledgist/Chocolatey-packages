$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
   checksum       = '5992ee6620f18689fef2536dbf615c5a6ed4dfedbee88626340bb01221d69d7f'
   checksum64     = 'ff38d8b8381ad7b7953c94aad833142851c27bf62070d9a41426ad148b42b3d0'
   checksumType   = 'sha256'
   silentArgs     = '/S /AllUsers'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

