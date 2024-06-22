$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   Url64bit       = 'https://releases.crystalexplorer.net/CrystalExplorer-21.5-windows-x86_64.exe'
   checkSum64     = '320c450ea5b0de6560ddf55f4f9b0de47dcb8c047a1ad98b8c81f3b87f22ebf4'
   checkSumType   = 'sha256'
   silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP- /LOG=`"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).Install.log`""
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs

