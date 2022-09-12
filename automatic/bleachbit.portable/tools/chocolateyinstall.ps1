$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$ZipFile   = Get-ChildItem -Path $toolsDir -Filter '*.zip' | Sort-Object LastWriteTime | Select-Object -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile.FullName -Destination $FolderOfPackage

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'BleachBit.lnk'
   TargetPath       = (Get-ChildItem $FolderOfPackage -filter "bleachbit.exe" -Recurse).FullName
   RunAsAdmin       = $true
}
Install-ChocolateyShortcut @ShortcutArgs
