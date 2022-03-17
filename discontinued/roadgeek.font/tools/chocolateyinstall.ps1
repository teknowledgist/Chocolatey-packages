$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip').FullName
$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$UnzipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $fileLocation
   Destination    = $UnzipDir
}
Get-ChocolateyUnzip @UnzipArgs

$Installed = Add-Font $UnzipDir -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $FontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

Remove-Item $fileLocation -Force