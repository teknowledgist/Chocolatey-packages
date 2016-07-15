$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::CommonDesktopDirectory))
$shortcut = Join-Path $desktop 'Eclipse IDE (neon).lnk'
 
if (Test-Path $shortcut) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    Remove-Item $shortcut
}

