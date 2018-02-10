$desktop = [Environment]::GetFolderPath("Desktop")
$shortcut = Join-Path $desktop 'MasterPassword.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}

Uninstall-BinFile 'MasterPassword'
