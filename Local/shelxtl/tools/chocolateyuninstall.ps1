$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'shelxtl'

Remove-Item 'HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\XP, XPREP, XSHELL' -Recurse -Force
Remove-Item 'C:\SAXI' -Recurse -Force

New-Alias ucev Uninstall-ChocolateyEnvironmentVariable
ucev 'SAXI$ROOT:'    'Machine'
ucev 'SXTL$SYSTEM:'  'Machine'
ucev 'SXTL'          'Machine'
ucev 'SAXI$USERNAME' 'Machine'
ucev 'SAXI$SITE'     'Machine'

$CurrentPath = Get-Environmentvariable -name 'path' 'Machine'
$ReducedPath = ($CurrentPath -split ';' | ? {$_ -notlike 'c:\SAXI*'}) -join ';'
Install-ChocolateyEnvironmentVariable 'path' $ReducedPath 'Machine'

$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\programs\$packageName.lnk"
if ([System.IO.File]::Exists($StartShortcut)) {
    Write-Debug "Found the Start menu shortcut. Deleting it..."
    [System.IO.File]::Delete($StartShortcut)
}

$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "$packageName.lnk" 
if ([System.IO.File]::Exists($DeskShortcut)) {
    Write-Debug "Found the Desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($DeskShortcut)
}