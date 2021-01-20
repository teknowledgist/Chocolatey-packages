$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = Get-ChildItem -Path $toolsDir -Filter '*.exe' | Sort-Object LastWriteTime | Select-Object -Last 1

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
  file         = $fileLocation.FullName
  softwareName = "$env:ChocolateyPackageName*"
  silentArgs   = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

New-Item "$($fileLocation.FullName).ignore" -Type file -Force | Out-Null
