$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'MEGAsync*'
   fileType       = 'EXE'
   url            = 'https://mega.nz/MEGAsyncSetup32.exe'
   url64          = 'https://mega.nz/MEGAsyncSetup64.exe'
   checksum       = 'd662f2f080ab9f67b6633b4bff4937654b5832d716df3eae816fa13336e54e06'
   checksum64     = '4ecdc13c48e08c09295356b3afc37e8e7dc60d7c9e624d7f64012ba93246006d'
   checksumType   = 'sha256'
   silentArgs     = '/S /AllUsers'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$null = New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force

