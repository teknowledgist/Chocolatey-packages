$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$Installed = Add-Font "$toolsDir\*.otf" -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} else {
   Write-Host "$Installed fonts were installed."
}

Remove-Item "$toolsDir\*.otf"
