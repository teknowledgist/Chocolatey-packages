$shortcut = Join-Path ([Environment]::GetFolderPath("commonstartmenu")) 'Programs\Image Analyzer.lnk'
 
if (Test-Path $shortcut) {
    Write-Debug "Found the Start Menu shortcut. Deleting it..."
    Remove-Item $shortcut -Force
}