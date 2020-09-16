$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile   = (Get-ChildItem $toolsDir -filter "*.zip").FullName
$Destination = Join-Path $env:ChocolateyPackageFolder "v$env:ChocolateyPackageVersion"

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $Destination

$targetPath = Get-ChildItem $Destination -filter "*GUI.exe" -Recurse
$null = New-Item "$($targetPath.FullName).gui" -Type file -Force

$Linkname = $targetPath.BaseName + '.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath.FullName
