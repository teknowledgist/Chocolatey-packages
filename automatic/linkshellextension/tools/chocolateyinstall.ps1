$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Installers = Get-ChildItem $toolsDir -filter '*.exe' | Select-Object -ExpandProperty FullName

$packageArgs = @{
   packageName    = $env:chocolateyPackageName
   fileType       = 'EXE'
   File           = $Installers | Where-Object {$_ -match '32'}
   File64         = $Installers | Where-Object {$_ -match '64'}
   silentArgs     = '/S /noredist'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs 

foreach ($exe in $Installers) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}

