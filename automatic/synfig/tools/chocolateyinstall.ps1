$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/synfig/synfig/releases/download/v1.3.16/SynfigStudio-1.3.16-testing-2020.08.06-win32-bc82b.exe'
   url64bit       = 'https://github.com/synfig/synfig/releases/download/v1.3.16/SynfigStudio-1.3.16-testing-2020.08.06-win64-bc82b.exe'
   checksumType   = 'sha256'
   checksum       = 'db62c2f57b27ed69834de2998f9444f57c9aafdc78d9f2e8544ef545471a1a85'
   checksum64     = 'bac61279b229d953b03738581c160b6026b74d857fa470781225d9c4f59f80c1'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
