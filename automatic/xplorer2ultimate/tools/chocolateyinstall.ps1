$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 1

$File64 = ($Files | Where-Object {$_.Name -match '64'}).fullname

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File64         = $File64
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

foreach ($File in $Files) {
   Remove-Item $File.fullname -ea 0 -force
}
