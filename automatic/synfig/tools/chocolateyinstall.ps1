$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.13/SynfigStudio-1.3.13-testing-2020.03.14-win32-7816d.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.13/SynfigStudio-1.3.13-testing-2020.03.14-win64-7816d.exe'
   checksumType   = 'sha256'
   checksum       = 'a3112e89cbaf4aea9996477672b2bf69d48f9b5f424e45f068f2a3b20536a31b'
   checksum64     = '3fbd6caa0eea3acf768440036100157dbc06fcdee1e4786b94b19917dad709bc'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
