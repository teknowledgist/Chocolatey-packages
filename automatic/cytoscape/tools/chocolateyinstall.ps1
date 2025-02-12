$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   Url64bit       = 'https://github.com/cytoscape/cytoscape/releases/download/3.10.3/Cytoscape_3_10_3_windows_64bit.exe'
   Checksum64     = 'ef53eb6ed290736663d0312c6d149a91155957f15b6a13eb66f4fff2f3d5bd9b'
   ChecksumType   = 'sha256'
   silentArgs    = "-q"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
