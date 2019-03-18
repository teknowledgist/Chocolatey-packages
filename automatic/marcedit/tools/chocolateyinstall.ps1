$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Installers = Get-ChildItem $toolsDir -filter "*.msi"

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   File           = ($Installers | Where-Object {$_.basename -match '32'}).FullName
   File64         = ($Installers | Where-Object {$_.basename -match '64'}).FullName
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

