$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   url            = 'https://go.microsoft.com/fwlink/?linkid=2102613'
   Checksum       = '37a365ed26669fa0fa5cd5308ea9c9e2a42880113cbb4f16899f85447c57dca5'
   ChecksumType   = 'sha256'
   silentArgs    = "-Install -ACCEPTEULA -DISABLETURNONRDP -Silent"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
