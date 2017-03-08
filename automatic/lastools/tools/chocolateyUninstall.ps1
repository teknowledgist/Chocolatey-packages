$packageName = 'lastools'

$shortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'LAStool.lnk'
if (Test-Path $shortcut) {
    Write-Verbose 'Found the desktop shortcut. Deleting it...'
    Remove-Item $shortcut
}

# This avoids having to modify uninstall if the zip install file changes names
$installedZipFile = (Get-ChildItem $env:chocolateyPackageFolder -filter '*.zip.txt').name.trim('.txt')

Uninstall-ChocolateyZipPackage  $packageName $installedZipFile
