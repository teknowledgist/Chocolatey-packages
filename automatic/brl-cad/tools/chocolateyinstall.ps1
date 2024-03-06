$ErrorActionPreference = 'Stop'

$ToolsDir = Split-Path $MyInvocation.MyCommand.Definition

$Installer = Get-ChildItem "$ToolsDir\*.msi","$ToolsDir\*.exe" | 
               Sort-Object LastWriteTime | Select-Object -Last 1

if ($Installer.FullName -match '\.exe$') {
   $SilentArg = '/S'
   $Type = 'exe'
} else {
   $SilentArg = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   $Type = 'msi'
}

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = $Type
   File           = $Installer.FullName
   silentArgs     = $SilentArg
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

remove-item $Installer.fullname -Force

