$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.3/SynfigStudio-1.5.3-2024.08.23-win32-3b7c5.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.3/SynfigStudio-1.5.3-2024.08.23-win64-3b7c5.exe'
   checksumType   = 'sha256'
   checksum       = 'c1dfd2954605607e4ed5062ae860d5ad53513d87105501b191ff010957f03af7'
   checksum64     = 'b037a78e45ae5272f095412f51b7634fd7a4226291d82a135d0e0459b8340d92'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
