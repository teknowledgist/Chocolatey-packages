$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'http://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_win32.exe'
   url64bit       = 'http://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_X64.exe'
   checksumType   = 'sha256'
   checksum       = '2e62d4a7d4cdd4d36f67a82cd64d1187cb6411fdb5863c79faa09c7c751390c1'
   checksum64     = 'dcaa5ef7c34846d1a41d6dc67d4887c86e2351c2a6561363e86e280a872d3f97'
   silentArgs     = '/S /noredist'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
