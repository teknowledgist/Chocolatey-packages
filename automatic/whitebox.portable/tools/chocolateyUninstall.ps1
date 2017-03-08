$shortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'WhiteBoxGAT.lnk'
 
if (Test-Path $shortcut) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    Remove-Item $shortcut -Force
}