$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$Installed = Add-Font "$toolsDir\*.ttf" -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $FontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

