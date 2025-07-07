$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallerFiles = Get-ChildItem -Path $toolsDir -Filter "*.msi" |
                     Sort-Object LastWriteTime | 
                     Select-Object -ExpandProperty FullName -Last 2

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = '.msi'
   File           = $InstallerFiles | Where-Object {$_ -match 'x86'}
   File64         = $InstallerFiles | Where-Object {$_ -match 'x64'}
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes = @(0,3010)
}
Install-ChocolateyInstallPackage @InstallArgs

$msis = Get-ChildItem $toolsDir -filter *.msi -Recurse |select -ExpandProperty fullname
foreach ($msi in $msis) {
   Remove-Item $msi -ea 0 -force
}
