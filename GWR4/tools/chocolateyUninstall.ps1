$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory))
$shortcut = Join-Path $desktop 'GWR4.lnk'
 
if (Test-Path $shortcut) {
    Write-Debug 'Found the desktop shortcut. Deleting it...'
    Remove-Item $shortcut
}

$StartMenu =  $([Environment]::GetFolderPath([Environment+SpecialFolder]::Programs))
$shortcut = Join-Path $StartMenu 'GWR4.lnk'
if (Test-Path $shortcut) {
    Write-Debug 'Found the StartMenu shortcut. Deleting it...'
    Remove-Item $shortcut
}

$folder = Join-path $env:ProgramFiles 'GWR4'
if (Test-Path $folder) {
   Write-Debug 'Deleting install directory.'
   Remove-Item $folder -Recurse -Force
}