$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
#   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.3/midori-11.3.3.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.6.5/midori-11.6.5.win64.installer.exe'
   checksumType   = 'sha256'
#   checksum       = 'be8f251a4cbb3e1c2e84c6b27db832e3df96093dbeed68b7ecab9209fb8da02f'
   checksum64     = 'e90a96d55e430e21e1128587776c8904479d8c498d97c9654727d3a3c8bf6506'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
