$StartMenuFolder = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu'

$StartShortcuts = gci $StartMenuFolder -Filter 'TinyTask.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item $Shortcut.fullname -Force
}
