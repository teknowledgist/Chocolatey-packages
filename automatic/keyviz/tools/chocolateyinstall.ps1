$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFile = Get-ChildItem -Path $toolsDir -Filter "*.msi" |
                     Sort-Object LastWriteTime | 
                     Select-Object -ExpandProperty FullName -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'MSI'
   File           = $InstallerFile
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes = @(0,3010)
}
Install-ChocolateyInstallPackage @InstallArgs

Remove-Item $InstallerFile -ea 0 -force

