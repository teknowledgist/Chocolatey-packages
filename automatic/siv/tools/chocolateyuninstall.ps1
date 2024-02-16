$StartMenuFolder = Join-Path -Path $env:ProgramData -ChildPath 'Microsoft\Windows\Start Menu'

$StartShortcuts = Get-ChildItem -Path $StartMenuFolder -Filter 'SIV.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item -Path $Shortcut.fullname -Force
}
