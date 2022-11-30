$ErrorActionPreference = 'Stop'

$ModuleName = $env:ChocolateyPackageName.replace('.powershell','')
$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$TrackInstalls = Join-Path $toolsDir -ChildPath 'installations.saved'

if (Test-Path -Path $TrackInstalls) {
    $removePaths = Get-Content -Path $TrackInstalls
   ForEach ($path in $removePaths) {
       Write-Verbose "Removing all version of '$ModuleName' from '$path'."
       Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
   }
}
else {
   Uninstall-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue
}

