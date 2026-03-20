$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.5/SynfigStudio-1.5.5-2026.03.15-win32-79bf7.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.5/SynfigStudio-1.5.5-2026.03.15-win64-79bf7.exe'
   checksumType   = 'sha256'
   checksum       = '0d95d005838dbdc407219f2fdc7f3b91b0c165b466299d97656efea60b274848'
   checksum64     = '065793c39c42ac9b45ed51060b3ecb2e386c413a669ff08aaf2bfc566dbc38bf'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
