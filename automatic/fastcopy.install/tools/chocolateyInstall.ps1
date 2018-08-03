$ErrorActionPreference = 'Stop'
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName

# Extract zip
$UnZipPath = Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$InstallerPath = (Get-ChildItem -Path $UnZipPath -filter '*.exe').FullName

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Start-ChocolateyProcessAsAdmin -ExeToRun $InstallerPath -WorkingDirectory $UnZipPath
