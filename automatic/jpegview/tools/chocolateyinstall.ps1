$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Installers = Get-ChildItem $toolsDir -filter '*.msi' | 
                  Sort-Object LastWriteTime | 
                  Select-Object -ExpandProperty fullname -Last 2

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   File          = $Installers | Where-Object {$_ -match '32_'}
   File64        = $Installers | Where-Object {$_ -match '64_'}
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

$Installers | ForEach-Object { remove-item $_ -Force }
