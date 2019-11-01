$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile   = (Get-ChildItem $toolsDir -filter '*.zip').FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $env:ChocolateyPackageFolder

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'BleachBit.lnk'
   TargetPath       = (Get-ChildItem $env:ChocolateyPackageFolder -filter "bleachbit.exe" -Recurse).FullName
   RunAsAdmin       = $true
}
Install-ChocolateyShortcut @ShortcutArgs
