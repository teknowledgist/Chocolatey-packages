$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.15/SynfigStudio-1.3.15-testing-2020.07.23-win32-b5b32.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.15/SynfigStudio-1.3.15-testing-2020.07.23-win64-b5b32.exe'
   checksumType   = 'sha256'
   checksum       = 'a27f5c57edc50a6ae0c89111fb709c5df7fe98f9281dba679cd3c714f0c16c0c'
   checksum64     = '714884cab3fd7575f97b26828b52cfe3bea8757ce01db39329504b0572824819'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
