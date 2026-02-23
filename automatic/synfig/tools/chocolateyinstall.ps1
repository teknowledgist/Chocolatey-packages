$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.4/SynfigStudio-1.5.4-2026.01.18-win32-79417.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.4/SynfigStudio-1.5.4-2026.01.18-win64-79417.exe'
   checksumType   = 'sha256'
   checksum       = '0cc0801db36f783732486410c8e742d1b048f078c82b1520d12396aad45c026c'
   checksum64     = 'e057e7722f04b7f45fa8a01f35b5eb618f5c0962e9dc536d283cc46aba610528'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
