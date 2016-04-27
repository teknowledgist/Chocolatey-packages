$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory))
$shortcut = Join-Path $desktop 'Swiss-PdbViewer.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}