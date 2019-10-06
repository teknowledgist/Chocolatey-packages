$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'Slicer*'
   fileType       = 'EXE'
   url64bit       = 'https://slicer.kitware.com/midas3/download?bitstream=1023243'
   checksum64     = '5a459896883fba721ab27052d74c6ba7d49bd73b1b87c3a2f389a0db76955a50'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null

