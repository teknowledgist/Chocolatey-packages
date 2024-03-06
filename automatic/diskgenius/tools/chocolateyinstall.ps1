$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://www.diskgenius.com/dyna_download/?software=DGEngSetup5511508.exe'
   Checksum       = '3fe4b4318f3dd58734feacf07998149ac9a1f2580c5775fd502ec20baf006264'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

