$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://go.microsoft.com/fwlink/?linkid=2102613'
   Checksum       = '2c1081ebcf09b2ce04edab2b80b413ea5ecc358a5b327726c2c7d4174ac754f4'
   ChecksumType   = 'sha256'
   silentArgs    = "-Install -ACCEPTEULA -DISABLETURNONRDP -Silent"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
