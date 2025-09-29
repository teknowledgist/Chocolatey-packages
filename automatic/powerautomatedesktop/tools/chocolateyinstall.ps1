$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://go.microsoft.com/fwlink/?linkid=2102613'
   Checksum       = '8f727e5ce4dcc9162f6e58c64cfcc0eb93385db2dafa6de141567e6ca6b8d387'
   ChecksumType   = 'sha256'
   silentArgs    = "-Install -ACCEPTEULA -DISABLETURNONRDP -Silent"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
