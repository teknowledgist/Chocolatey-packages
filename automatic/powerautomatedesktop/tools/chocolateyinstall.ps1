$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://go.microsoft.com/fwlink/?linkid=2102613'
   Checksum       = '246011a12635b0c64e348741d6e6f767340bcfb16787e41251b8758ba54e5e41'
   ChecksumType   = 'sha256'
   silentArgs    = "-Install -ACCEPTEULA -DISABLETURNONRDP -Silent"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
