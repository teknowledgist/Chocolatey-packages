$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipFile = Get-ChildItem -Path $toolsDir -Filter '*.zip' | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$UnzipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = $UnzipDir
}

Get-ChocolateyUnzip @UnzipArgs

$FontFiles = Get-ChildItem $UnzipDir -Include '*.ttf' -Recurse | 
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

$null = Remove-Item -Path $ZipFile -Force
