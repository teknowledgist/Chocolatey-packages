$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://www.diskgenius.com/dyna_download/?software=DGEngSetup6101725.exe'
   Checksum       = 'daa6c44d2f1385eb3805ee8e3e21a8542ce242e42ae0e8ebbcd243f7f631caa7'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

