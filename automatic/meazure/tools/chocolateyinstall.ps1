$ErrorActionPreference = 'Stop'

$Build = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber
$1607Build = 14393
if ($Build -lt $1607Build) {
   Throw 'Meazure requires Windows 10 version 1607 or newer to install.  Exiting.'
}

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$InstallFile = Get-ChildItem -Path $toolsDir -Filter '*.exe' | 
                  Sort-Object LastWriteTime | Select-Object -Last 1

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
  file64       = $InstallFile.FullName
  softwareName = "$env:ChocolateyPackageName*"
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $InstallFile.FullName -ea 0 -force
