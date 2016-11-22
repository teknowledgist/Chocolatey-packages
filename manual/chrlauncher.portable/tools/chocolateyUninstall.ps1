$PackageName = "chrlauncher.portable"
$version = '1.9.4'
$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)

Remove-Item (Join-path $PackageDir ($PackageName.split('.')[0] + $version)) -Recurse -Force

$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory))
$shortcut = Join-Path $desktop 'Chromium Launcher.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}

