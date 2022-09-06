$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$PackageFolder = Split-Path -Parent $toolsDir

$logPath = Join-Path $PackageFolder "PyDevInstallLocation.txt"
$installationPath = Get-Content $logPath
Write-Verbose "Previous Installation Path: $installationPath"
 
# Remove previous versions
$Previous = gci $installationPath,"$installationPath\*\*" -Filter "*.python.pydev*" |
                  select -ExpandProperty fullname
if ($Previous) {
   $Previous | % { Remove-Item $_ -Recurse -Force }
}

