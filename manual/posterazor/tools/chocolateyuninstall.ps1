$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartPrograms 'PosteRazor.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the Start Menu shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}
