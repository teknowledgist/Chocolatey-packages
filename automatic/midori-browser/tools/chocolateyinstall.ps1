$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.2/midori-11.3.2.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.2/midori-11.3.2.win64.installer.exe'
   checksumType   = 'sha256'
   checksum       = '2b321fb3afe0c38a18fe2d9defa20c09877672462b1e5e2837b06792b969fb5d'
   checksum64     = 'ae8321a6ac8284761b4422e50c83a7faad90d663594cb25af8a349a5462eb351'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
