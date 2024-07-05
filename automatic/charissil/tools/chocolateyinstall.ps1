$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName
$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$UnzipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $fileLocation
   Destination    = $UnzipDir
}
Get-ChocolateyUnzip @UnzipArgs

$FontFiles = Get-ChildItem $UnzipDir -Filter "*.TT*" -Recurse | 
                  Select-Object -ExpandProperty FullName

$Installed = Add-Font $FontFiles -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $FontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

Remove-Item $fileLocation -Force
