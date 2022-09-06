$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove old versions
$Previous = Get-ChildItem $PackageFolder -Filter v* | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

$Destination = Join-Path $PackageFolder "v$env:ChocolateyPackageVersion"

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $Destination

$targetPath = Get-ChildItem $Destination -filter "*GUI.exe" -Recurse
$null = New-Item "$($targetPath.FullName).gui" -Type file -Force

$Linkname = $targetPath.BaseName + '.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath.FullName
