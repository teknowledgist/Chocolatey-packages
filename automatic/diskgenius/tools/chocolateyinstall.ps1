$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://www.diskgenius.com/dyna_download/?software=DGEngSetup6011645.exe'
   Checksum       = 'a3670b91bfa882fd7aaa8e0b293e28f49b7cb893ca6d34c7a510c64412afac77'
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

