$ErrorActionPreference = 'Stop'

$packageName = 'graph'
$Url         = 'https://www.padowan.dk/bin/SetupGraph-4.4.2.exe'
$Checksum    = '1967affa93df9bc9103d47f35f51ecd4422483154f07ffbdf813a66eb35d66a5'

$InstallArgs = @{
   packageName    = $packageName
   installerType  = 'exe'
   url            = $Url
   Checksum       = $Checksum
   ChecksumType   = 'sha256'
   silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

