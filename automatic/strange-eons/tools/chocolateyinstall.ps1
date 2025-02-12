$ErrorActionPreference = 'Stop'  # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallFile = Get-ChildItem -Path $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $InstallFile.FullName
   silentArgs     = '-q'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $InstallFile.FullName -ea 0 -force
