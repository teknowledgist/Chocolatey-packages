$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

$ZipFile   = Get-ChildItem -Path $toolsDir -Filter '*.zip' | Sort-Object LastWriteTime | Select-Object -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile.FullName -Destination $PackageFolder

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'BleachBit.lnk'
   TargetPath       = (Get-ChildItem $PackageFolder -filter "bleachbit.exe" -Recurse).FullName
   RunAsAdmin       = $true
}
Install-ChocolateyShortcut @ShortcutArgs
