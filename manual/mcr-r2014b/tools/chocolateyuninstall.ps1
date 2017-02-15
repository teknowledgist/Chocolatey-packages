$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'mcr-r2014b'
$Version = '8.4'
$softwareName = 'MATLAB Compiler Runtime ' + $Version

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match $softwareName} |
                     Select-Object -ExpandProperty UninstallString

$InstalledPath = $unexe -replace "^(.*v$($version.replace('.','')))\\.*",'$1'

$UninstallArgs = @{
   packageName = $packageName
   fileType = 'exe'
   file = $unexe
   silentArgs = '"' + $InstalledPath + '" -mode silent'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

if (Test-Path $InstalledPath) {
   Remove-Item $InstalledPath -Recurse
}