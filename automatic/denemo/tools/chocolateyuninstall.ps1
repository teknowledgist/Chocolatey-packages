$StartMenuFolder = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu'

$StartShortcuts = Get-ChildItem $StartMenuFolder -Filter 'Denemo.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item $Shortcut.fullname -Force
}
