$ErrorActionPreference = 'Stop'  # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = Get-ChildItem -Path $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation.FullName
   silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
New-Item "$($fileLocation.FullName).ignore" -Type file -Force | Out-Null
