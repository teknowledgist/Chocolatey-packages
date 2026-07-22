$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
#   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.3/midori-11.3.3.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.9.1/midori-11.9.1.win64.installer.exe'
   checksumType   = 'sha256'
#   checksum       = 'be8f251a4cbb3e1c2e84c6b27db832e3df96093dbeed68b7ecab9209fb8da02f'
   checksum64     = '2f6ed1b58fab84d0c68b5a98e2bbddcbac2c3be91526f6f7304e3d6d9fc3d3dd'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
