$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

$DisplayedVersion = $env:ChocolateyPackageVersion.split('.')[0-1] -join '.'

$UnzipLog = Get-ChildItem $PackageFolder -Filter "*.zip.txt" |
                  Sort-Object creationtime | Select-Object -last 1
If ($UnzipLog) {
   $InstallDir = Get-Content $UnzipLog.FullName | Select-Object -First 1
} else {
   $InstallDir = Join-Path $env:ProgramData "$env:ChocolateyPackageName-$DisplayedVersion"
}

$ShortcutName = "Olex2-$DisplayedVersion.lnk"
$DeskShortcut = Join-Path "$env:PUBLIC\Desktop" $ShortcutName
$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$ShortcutName"

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