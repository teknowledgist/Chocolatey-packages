$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'http://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_win32.exe'
   url64bit       = 'http://schinagl.priv.at/nt/hardlinkshellext/HardLinkShellExt_X64.exe'
   checksumType   = 'sha256'
   checksum       = '74d21fb9940df5af6d7a661cf6f306e9444a885f5bd367afce92847046214a6f'
   checksum64     = 'f148bb3954b83b6ee269c17fa650f3a0248ba686239b1cff21ff17825b046e23'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
