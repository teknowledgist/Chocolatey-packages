$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.2.2/SynfigStudio-1.2.2-18.09.14-win32-286f1.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.2.2/SynfigStudio-1.2.2-18.09.14-win64-286f1.exe'
   checksumType   = 'sha256'
   checksum       = '70ed5269fde360608cafed805640908b2371067948456e0055c87a29e4c773d2'
   checksum64     = '8976eecc273e3c22c299c0a7c4aced53a1e032acb67b76479cccfd2e472c8515'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
