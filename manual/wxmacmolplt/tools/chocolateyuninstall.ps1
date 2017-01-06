$packageName = 'wxMacMolPlt'
$shortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\programs\$packageName.lnk"
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the Start menu shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}