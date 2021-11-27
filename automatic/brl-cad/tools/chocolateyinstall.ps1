$ErrorActionPreference = 'Stop'

$Installer = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.msi' | 
               Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Installer.FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

remove-item $Installer.fullname -Force

