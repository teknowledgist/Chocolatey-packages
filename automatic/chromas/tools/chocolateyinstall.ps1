$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'http://www.technelysium.com.au/Chromas265Setup.exe'
   Checksum       = '3d8cc4dccce577a6ba147d552d942a840fa83db48590d0922f45ab0bda7871c3'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

