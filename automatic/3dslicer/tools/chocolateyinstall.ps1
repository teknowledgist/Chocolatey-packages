$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'Slicer*'
   fileType       = 'EXE'
   url64bit       = 'https://slicer-packages.kitware.com/api/v1/item/637f7a7f517443dc5dc73276/download'
   checksum64     = '4ae73b5ab02949ceba1795453827a2eefa852040c9f30706d2973effae5889c5'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null

