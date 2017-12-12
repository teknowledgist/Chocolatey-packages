$desktop = [Environment]::GetFolderPath("Desktop")
$shortcut = Join-Path $desktop 'USB Image Tool.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}
