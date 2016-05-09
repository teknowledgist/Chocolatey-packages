if (test-path (Join-Path ${env:ProgramFiles(x86)} 'CrystalExplorer3.1')) {
   Remove-Item (Join-Path ${env:ProgramFiles(x86)} 'CrystalExplorer3.1') -Recurse -Force
}

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) 'CrystalExplorer.lnk'

if (Test-Path $shortcut) {
   Remove-Item $shortcut
}