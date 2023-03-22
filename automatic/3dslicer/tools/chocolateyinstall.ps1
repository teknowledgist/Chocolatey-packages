$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'Slicer*'
   fileType       = 'EXE'
   url64bit       = 'https://slicer-packages.kitware.com/api/v1/item/63f5decd8939577d9867c878/download'
   checksum64     = '690659af67605aceb122559c8ffd4f9c2248cbd95ed5180edad7d153dc15596e'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null

