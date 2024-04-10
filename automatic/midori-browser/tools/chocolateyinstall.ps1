$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url            = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.1/midori-11.3.1.win32.installer.exe'
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.3.1/midori-11.3.1.win64.installer.exe'
   checksumType   = 'sha256'
   checksum       = '67be714d1210030e576965b420fd907f20feca9dd02b0e03a441fef5ac312dc9'
   checksum64     = 'f32095c6ba7c999dcec785b6d9d3a481d2483441a2f1ab2d73129cecb1634223'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
