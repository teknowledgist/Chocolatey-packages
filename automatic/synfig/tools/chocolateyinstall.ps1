$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.4.2/SynfigStudio-1.4.2-2021.07.29-win32-dc54d.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.4.2/SynfigStudio-1.4.2-2021.07.29-win64-dc54d.exe'
   checksumType   = 'sha256'
   checksum       = '9354bafb44248c50fe1538cd605ac3607a4f8fd7d47ca746df439b9beef7cbac'
   checksum64     = '993b97b686712fa03155b90162d11fd7d6a0af91bb094f2abdbd8288ab1aa484'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
