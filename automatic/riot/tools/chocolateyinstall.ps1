$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   file64         = $fileLocation
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fileLocation -ea 0 -force

