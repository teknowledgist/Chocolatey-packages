$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Installers = Get-ChildItem $toolsDir -Filter '*.exe' | 
               Sort-Object LastWriteTime | Select-Object -expand FullName -Last 2

$pp = Get-PackageParameters
if (!$pp['config']) {
   'userMode$Integer=1' | Out-File "$toolsDir\response.varfile"
   $VarFile = 'response.varfile'
} else {
    if (!(Test-Path $pp['Config'] -PathType Leaf)) {
        Write-Error "`nThe configuration parameter, '$($pp['Config'])' is not an accessible path!"
    } else {
       Write-Host "You wish to use the installation configuration file: $($pp['Config'])" -ForegroundColor Cyan
       Copy-Item $pp['Config'] $toolsDir
       $VarFile = ([System.IO.DirectoryInfo]($pp['Config'])).Name
    }
}

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'exe'
   File           = $Installers | Where-Object {$_ -match 'x32'}
   File64         = $Installers | Where-Object {$_ -match 'x64'}
   silentArgs     = "-q -varfile $VarFile"
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Installers) {
   Remove-Item $exe -ea 0 -force
}

