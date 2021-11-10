$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.1/SynfigStudio-1.5.1-2021.10.21-win32-2cb6c.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.1/SynfigStudio-1.5.1-2021.10.21-win64-2cb6c.exe'
   checksumType   = 'sha256'
   checksum       = '068bf52c70300eb1f9bba59cbc2aa6815748811722fb03d61b8fac2398042858'
   checksum64     = '93ed2b093cc4e113252394304e35f5fcd9d80f43e98ee9ecbc6abcbf1250e93b'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
