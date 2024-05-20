$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.3/midori-11.3.3.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.3/midori-11.3.3.win64.installer.exe'
   checksumType   = 'sha256'
   checksum       = 'be8f251a4cbb3e1c2e84c6b27db832e3df96093dbeed68b7ecab9209fb8da02f'
   checksum64     = '5b6d0826cfd123f7064ebe69af54e3b112ec82769c6adad6bbb87968322856e3'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
