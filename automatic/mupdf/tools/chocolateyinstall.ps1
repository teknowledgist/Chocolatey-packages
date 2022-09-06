$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove old versions
$null = Get-ChildItem $PackageFolder -Filter $env:ChocolateyPackageName* | 
            Where-Object { $_.PSIsContainer } | Remove-Item -Force -Recurse

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $PackageFolder

Remove-Item -force $ZipFile -ea 0
