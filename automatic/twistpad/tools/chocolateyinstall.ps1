$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileType       = 'EXE'
   SoftwareName   = "$env:ChocolateyPackageName*"
   Url            = 'https://www.carthagosoft.net/downloads/TwistpadSetup.zip'
   ChecksumType   = 'sha256'
   Checksum       = '732a30a080168e23489fc0ee14236298583cd9d84018b4c63130d4a4aa35899a'
   SilentArgs     = '/S'
   ValidExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs 
