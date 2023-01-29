$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$File = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 1 -ExpandProperty Fullname

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File64         = $File
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $File -ea 0 -force
