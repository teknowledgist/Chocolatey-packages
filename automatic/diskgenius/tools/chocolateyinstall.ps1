$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://www.diskgenius.com/dyna_download/?software=DGEngSetup5601565.exe'
   Checksum       = 'e5c2310ac53a3c96f0f2716ab626199598828966ca2cca463c0b9b3853e996a2'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

