$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallFile = Get-ChildItem -Path $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | Select-Object -Last 1

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
  file         = $InstallFile.FullName
  softwareName = "$env:ChocolateyPackageName*"
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $InstallFile.FullName -ea 0 -force
