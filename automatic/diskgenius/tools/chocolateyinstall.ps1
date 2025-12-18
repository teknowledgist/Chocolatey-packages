$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://www.diskgenius.com/dyna_download/?software=DGEngSetup6111742.exe'
   Checksum       = 'be648b768d154230b8f9a7c8d7218d19b1308c6bd36be90d840807c96b54df37'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

