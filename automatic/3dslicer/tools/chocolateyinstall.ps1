$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'Slicer*'
   fileType       = 'EXE'
   url64bit       = 'https://slicer-packages.kitware.com/api/v1/item/679341f51357655fd5860615/download'
   checksum64     = 'e787a2146522dcad88520d58af39d262f649dd8ceeef97cea195eff53d507652'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null

