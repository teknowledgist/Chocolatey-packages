$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$Installer = Get-ChildItem $toolsDir -filter '*.msi' | 
                  Sort-Object LastWriteTime | 
                  Select-Object -ExpandProperty fullname -Last 1

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   File64        = $Installer
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

remove-item $Installer -Force
