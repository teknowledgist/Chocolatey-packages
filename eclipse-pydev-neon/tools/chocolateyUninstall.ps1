$InstallDir = Join-path (Split-path (Split-Path -parent $MyInvocation.MyCommand.Definition)) 'eclipse'
if (Test-Path $InstallDir) {
    Write-Debug 'Removing the application files...'
    Remove-Item $InstallDir -Recurse -Force
}

$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::CommonDesktopDirectory))
$shortcut = Join-Path $desktop 'PyDev IDE (Neon).lnk'
 
if (Test-Path $shortcut) {
    Write-Debug 'Found the desktop shortcut. Deleting it...'
    Remove-Item $shortcut -Force
}

