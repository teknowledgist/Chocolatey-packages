$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile   = (Get-ChildItem $toolsDir -filter '*.zip').FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $env:ChocolateyPackageFolder


$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'PosteRazor.lnk'
   TargetPath       = Join-Path $env:ChocolateyPackageFolder 'PosteRazor.exe'
   IconLocation     = Join-Path $toolsDir 'PosteRazor.ico'
}
Install-ChocolateyShortcut @ShortcutArgs
