$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.12/SynfigStudio-1.3.12-testing-2020.01.30-win32-8b3a3.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.12/SynfigStudio-1.3.12-testing-2020.01.30-win64-8b3a3.exe'
   checksumType   = 'sha256'
   checksum       = '2a2a897d087fd48f3e5b537011f07a4905c7df356a94db36c6db8b2d8e6f819f'
   checksum64     = '84980da1a59bcca77a47eac1dd45a4fc5a380d87360a04867a6fb71a33bebc62'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
