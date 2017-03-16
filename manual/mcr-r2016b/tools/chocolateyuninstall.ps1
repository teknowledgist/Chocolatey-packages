$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'mcr-r2016b'
$Version = '9.1'
$softwareName = 'MATLAB Runtime ' + $Version

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'
$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match $softwareName} |
                     Select-Object -ExpandProperty UninstallString

$InstalledPath = $unexe -replace "^(.*v$($version.replace('.','')))\\.*",'$1'
$unexe = $unexe.remove(($unexe.LastIndexOf($InstalledPath) - 1))

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