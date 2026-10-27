$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   Url64bit       = 'https://github.com/cytoscape/cytoscape/releases/download/3.10.5/Cytoscape_3_10_5_windows_64bit.exe'
   Checksum64     = 'cc6316c9e6dbf35ef468d2e5ef4ead6de1a665f76abfb15db31300097aba424f'
   ChecksumType   = 'sha256'
   silentArgs    = "-q"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
