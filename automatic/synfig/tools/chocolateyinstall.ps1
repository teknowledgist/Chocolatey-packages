$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.4.0/SynfigStudio-1.4.0-stable-2020.11.14-win32-b9862.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.4.0/SynfigStudio-1.4.0-stable-2020.11.14-win64-b9862.exe'
   checksumType   = 'sha256'
   checksum       = '9e124aea8446f9eaee83becb4323689e7bf30a7c6e787b8fff7a9cf6d0bfd145'
   checksum64     = '98b98a8322a8d2748d9488de2b8fe74c675d92a2d44ec9441fc7420866dfb425'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
