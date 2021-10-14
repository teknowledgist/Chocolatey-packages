$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$GUI = (Get-ChildItem $toolsDir -filter *.exe).fullname
$null = New-Item "$GUI.gui" -Type file -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms "Key-n-Stroke.lnk"
   TargetPath = $GUI
   IconLocation = (Get-ChildItem $toolsDir -filter *.ico).FullName
}
Install-ChocolateyShortcut @ShortcutArgs
