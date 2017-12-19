$ErrorActionPreference = 'Stop'
 
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$logPath = Join-Path $Env:ChocolateyPackageFolder "PyDevInstallLocation.txt"
$installationPath = Get-Content $logPath
Write-Verbose "Previous Installation Path: $installationPath"
 
# Remove previous versions
$Previous = gci $installationPath,"$installationPath\*\*" -Filter "*.python.pydev*" |
                  select -ExpandProperty fullname
if ($Previous) {
   $Previous | % { Remove-Item $_ -Recurse -Force }
}

