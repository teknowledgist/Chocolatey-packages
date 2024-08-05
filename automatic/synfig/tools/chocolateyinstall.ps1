$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.5.2/SynfigStudio-1.5.2-2024.08.04-win32-34f59.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.5.2/SynfigStudio-1.5.2-2024.08.04-win64-34f59.exe'
   checksumType   = 'sha256'
   checksum       = 'c8dfd267084af07577d073809d82d3a26da27f68cca8be207d01b5bbac8f0297'
   checksum64     = '46c04817314f360fb7f67781afe4b159d799fcced6e698a967bba594c7a1e6a2'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
