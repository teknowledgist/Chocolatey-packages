$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.0/SynfigStudio-1.5.0-2021.08.13-win32-32dd4.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.0/SynfigStudio-1.5.0-2021.08.13-win64-32dd4.exe'
   checksumType   = 'sha256'
   checksum       = 'fd53602f71a9557c578466fc4eefc14e9e40f0e06321d726105f648a1f02e13f'
   checksum64     = 'c3b0a3857e637e7e5a443dec7245a11e8e83f76c189b725f60d876e4d8bdbfd3'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
