$ErrorActionPreference = 'Stop'

$Installer = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.msi'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   File           = $Installer.FullName
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs


