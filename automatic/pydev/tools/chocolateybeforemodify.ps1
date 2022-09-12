$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir

$logPath = Join-Path $FolderOfPackage "PyDevInstallLocation.txt"
$installationPath = Get-Content $logPath
Write-Verbose "Previous Installation Path: $installationPath"
 
# Remove previous versions
$Previous = gci $installationPath,"$installationPath\*\*" -Filter "*.python.pydev*" |
                  select -ExpandProperty fullname
if ($Previous) {
   $Previous | % { Remove-Item $_ -Recurse -Force }
}

