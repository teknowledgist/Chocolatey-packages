$StartMenuFolder = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu'

$StartShortcuts = gci $StartMenuFolder -Filter 'RBTray.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item $Shortcut.fullname -Force
}
