$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.11/SynfigStudio-1.3.11-testing-19.02.09-win32-9583a.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.11/SynfigStudio-1.3.11-testing-19.02.09-win64-9583a.exe'
   checksumType   = 'sha256'
   checksum       = '8fd3d50b9223a4bededf65fbbd751f65ac4dc5617a6c64804af3f4366e3e94a0'
   checksum64     = '215692e150bcaea03e300c23e5ea97c5ddf601d02059f96c734e63a447288d7d'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
