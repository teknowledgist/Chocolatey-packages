$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Installers = Get-ChildItem $toolsDir -Filter '*.exe' | 
               Sort-Object LastWriteTime | Select-Object -expand FullName -Last 2

'userMode$Integer=1' | Out-File "$toolsDir\response.varfile"

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $Installers | Where-Object {$_ -match 'x32'}
   File64         = $Installers | Where-Object {$_ -match 'x64'}
   silentArgs     = '-q -varfile response.varfile'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Installers) {
   Remove-Item $exe -ea 0 -force
}

