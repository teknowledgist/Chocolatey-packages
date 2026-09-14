$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://go.microsoft.com/fwlink/?linkid=2102613'
   Checksum       = ''
   ChecksumType   = 'sha256'
   silentArgs    = "-Install -ACCEPTEULA -DISABLETURNONRDP -Silent"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
