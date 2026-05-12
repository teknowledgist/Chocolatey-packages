$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName*"
   url64bit       = 'https://github.com/goastian/midori-desktop/releases/download/v11.7.3/midori-11.7.3.win64.installer.exe'
   checksumType   = 'sha256'
   checksum64     = 'a4251c5c75d34145ff0dff8439829ff858dd5b5c11b30529e11656a7c695f185'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs 
