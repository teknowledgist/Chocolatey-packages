$StartMenuFolder = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu'

$StartShortcuts = Get-ChildItem $StartMenuFolder -Filter 'Giada.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item $Shortcut.fullname -Force
}
