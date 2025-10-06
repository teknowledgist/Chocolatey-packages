$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'exe'
   Url64bit       = 'https://github.com/cytoscape/cytoscape/releases/download/3.10.4/Cytoscape_3_10_4_windows_64bit.exe'
   Checksum64     = '4bd1ce47281d5ca03ec3d90de6a7bc03320a7f81df81d2d6f0c5febbd7a4346b'
   ChecksumType   = 'sha256'
   silentArgs    = "-q"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
