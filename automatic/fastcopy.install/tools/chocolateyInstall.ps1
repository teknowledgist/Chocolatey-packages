$ErrorActionPreference = 'Stop'; # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*64.zip').FullName

if (get-OSArchitectureWidth 32) {
   $ZipPath = $ZipPath -replace '64.zip','.zip'
}

# Extract zip
Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$InstallerPath = (Get-ChildItem -Path (Join-Path $env:TEMP $env:ChocolateyPackageName) -filter '*.exe').FullName

# Win7 complains the installer didn't run correctly.  This will prevent that.
#Set-Variable __COMPAT_LAYER=!Vista

& AutoHotKey $(Join-Path $toolsDir 'chocolateyInstall.ahk') $InstallerPath


