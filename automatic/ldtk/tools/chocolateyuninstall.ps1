$StartMenuFolder = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu'

$StartShortcuts = gci $StartMenuFolder -Filter 'LDtk.lnk' -Recurse

Foreach ($Shortcut in $StartShortcuts) {
   Remove-Item $Shortcut.fullname -Force
}

# Adjusting the install to make it for all-users breaks the removal of the installing user's 
#    Start Menu and desktop shortcuts.  If the installing user and uninstalling user are 
#    different, then this won't work and the icons will remain for the installing user.
if (Test-Path (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\LDtk.lnk')) {
   Remove-Item -Path (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\LDtk.lnk') -Force
}
if (Test-Path (Join-Path $env:USERPROFILE 'Desktop\LDtk.lnk')) { 
   Remove-Item -Path (Join-Path $env:USERPROFILE 'Desktop\LDtk.lnk') -Force
}

