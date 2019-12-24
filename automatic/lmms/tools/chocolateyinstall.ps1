$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Installers = Get-ChildItem -Path $toolsDir -Filter '*.exe'

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
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
New-Item (Join-path $toolsDir '.skipAutoUninstall') -Type file -Force | Out-Null
