$packageName = 'CrystalExplorer'
$Version = '3.1'

if (${Env:ProgramFiles(x86)}) { $InstallDir = ${Env:ProgramFiles(x86)} }
else { $InstallDir = $Env:ProgramFiles }

if (test-path (Join-Path $InstallDir "$packageName$Version")) {
   Remove-Item (Join-Path $InstallDir "$packageName$Version") -Recurse -Force
}

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonDesktopDirectory')) "$packageName.lnk"

if (Test-Path $shortcut) {
   Remove-Item $shortcut
}
