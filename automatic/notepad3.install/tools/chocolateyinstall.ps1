$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$Installers = Get-ChildItem $toolsDir -Filter '*.exe'

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   softwareName = "$env:ChocolateyPackageName*"
   fileType     = 'EXE' 
   File         = $installers | Where-Object {$_.name -match 'x86'} | Select-Object -ExpandProperty fullname
   File64       = $installers | Where-Object {$_.name -match 'x64'} | Select-Object -ExpandProperty fullname
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}
Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Installers) {
   remove-item $exe.fullname -Force
}
