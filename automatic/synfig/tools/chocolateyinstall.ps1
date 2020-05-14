$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.14/SynfigStudio-1.3.14-testing-2020.04.30-win32-b2662.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.14/SynfigStudio-1.3.14-testing-2020.04.30-win64-b2662.exe'
   checksumType   = 'sha256'
   checksum       = '2e2199507505727ea53b5488e31104a85eeee4ef1c6e22593bd3c3b9d51383aa'
   checksum64     = '86078cabd82bc190c94a6c7ce986c23ca5871bf637a491052b05c0e78841cc69'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
