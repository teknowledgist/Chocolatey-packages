$ErrorActionPreference = 'Stop'

$ToolsDir = Split-Path $MyInvocation.MyCommand.Definition
$Installer = Get-ChildItem $ToolsDir -Filter '*.msi' | 
               Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Installer.FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
