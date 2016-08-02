$InstallDir = Join-path (Split-path (Split-Path -parent $MyInvocation.MyCommand.Definition)) 'WhiteboxGAT'
if (Test-Path $InstallDir) {
    Write-Debug "Removing the application files..."
    Remove-Item $InstallDir -Recurse -Force
}

$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory))
$shortcut = Join-Path $desktop 'WhiteBoxGAT.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}