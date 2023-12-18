$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'Slicer*'
   fileType       = 'EXE'
   url64bit       = 'https://slicer-packages.kitware.com/api/v1/item/65783bef83a3201b44d52468/download'
   checksum64     = '5dc5d3abba7f2febc9ac5b75b25add7f732cae3fb81642000a944d6e3e7f480c'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null

