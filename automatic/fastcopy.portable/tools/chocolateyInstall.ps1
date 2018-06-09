$ErrorActionPreference = 'Stop'
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*64.zip').FullName

if (get-OSArchitectureWidth 32) {
   $ZipPath = $ZipPath -replace '64.zip','.zip'
}

# Extract zip
$UnZipPath = Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$InstallerPath = (Get-ChildItem -Path $UnZipPath -filter '*.exe').FullName

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile","$env:ChocolateyPackageFolder" -PassThru
Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$($ahkProc.Id)"

Start-ChocolateyProcessAsAdmin -ExeToRun $InstallerPath -WorkingDirectory $UnZipPath

# Prevent the installer from being on the path
$setupFile = Get-ChildItem -Path $env:ChocolateyPackageFolder -filter '*setup.exe' -Recurse| Select-Object -ExpandProperty FullName
if ($setupFile) {
   foreach ($file in $setupFile) {
      $null = New-Item "$File.ignore" -type file -force
   }
}

