$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.2.2/midori-11.2.2.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.2.2/midori-11.2.2.win64.installer.exe'
   checksumType   = 'sha256'
   checksum       = 'b1c2b5de270ae8982b8d781660ed14b02fdafebbf758b745d51a726c90869388'
   checksum64     = '0d0103b30aafd325c16e606f9ba8d97c985e454330a58ce4188c0705b357a744'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
