$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Installers = Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 2

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = ($Installers | Where-Object {$_.basename -match '32'}).FullName
   File64         = ($Installers | Where-Object {$_.basename -match '64'}).FullName
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

$exes = Get-ChildItem $toolsDir -filter *.exe -Recurse |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   Remove-Item $exe -ea 0 -force
}
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
