$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.4.1/SynfigStudio-1.4.1-2021.04.27-win32-33efb.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.4.1/SynfigStudio-1.4.1-2021.04.27-win64-33efb.exe'
   checksumType   = 'sha256'
   checksum       = 'ec78bfb2eaa53245c9320ebe897cf91541e019b664dc9c5c071bf2d1418c14fd'
   checksum64     = 'af6e639cbeab96e0f35f4227e6f4c74a534968b25fde0eaacb0587b4ce4c00a1'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
