$packageName = 'Olex2'

$InstallDir = Join-Path $env:ProgramData $packageName

$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Olex2-1.2.lnk'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Olex2-1.2.lnk'

if ([System.IO.File]::Exists($DeskShortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($DeskShortcut)
}

if ([System.IO.File]::Exists($StartShortcut)) {
    Write-Debug "Found the Start Menu shortcut. Deleting it..."
    [System.IO.File]::Delete($StartShortcut)
}

if (Test-Path $InstallDir) {
    Write-Debug "Found the Install Directory. Deleting it..."
      Remove-Item $InstallDir -Recurse -Force
}