$ErrorActionPreference = 'Stop' 

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation.FullName = Get-ChildItem -Path $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | Select-Object -Last 1

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $fileLocation.FullName
   silentArgs     = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
Remove-Item $fileLocation.FullName -ea 0 -force
