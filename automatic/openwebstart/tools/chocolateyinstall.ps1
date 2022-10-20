$ErrorActionPreference = 'Stop'

$Installers = Get-ChildItem (Split-Path $MyInvocation.MyCommand.Definition) -Filter '*.exe' | 
               Sort-Object LastWriteTime | Select-Object -expand FullName -Last 2

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $Installers | Where-Object {$_ -match 'x32'}
   File64         = $Installers | Where-Object {$_ -match 'x64'}
   silentArgs     = '-q'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Installers) {
   Remove-Item $exe -ea 0 -force
}

