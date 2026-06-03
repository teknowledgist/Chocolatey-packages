$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.8/midori-11.8.win64.installer.exe'
   checksumType   = 'sha256'
   checksum64     = 'd8ac4213f094ebd432aea54deeea86630271d7b02d86edae013457a360d4e8b3'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
