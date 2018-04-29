$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*_x64.zip').FullName

if (get-OSArchitectureWidth 32) {
   $ZipPath = $ZipPath -replace '_x64',''
}

# Extract zip
Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP "$ChocolateyPackageName")

$UserArguments = Get-PackageParameters

if ($UserArguments.ContainsKey('NoSubs')) {
   Write-Host 'You want FastMenu options directly in context menus (not in submenus).'
   $NoSubs = 'NoSubs'
}

# Win7 complains the installer didn't run correctly.  This will prevent that.
Set-Variable __COMPAT_LAYER=!Vista

& AutoHotKey $(Join-Path $env:ChocolateyPackageFolder 'tools\chocolateyInstall.ahk') $(Join-Path $env:TEMP "$ChocolateyPackageName\setup.exe") $NoSubs


