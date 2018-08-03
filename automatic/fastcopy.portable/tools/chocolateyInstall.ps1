$ErrorActionPreference = 'Stop'
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$ZipPath = (Get-ChildItem -Path $toolsDir -filter '*.zip').FullName

# Extract zip
$UnZipPath = Get-ChocolateyUnzip -FileFullPath $ZipPath -Destination (Join-Path $env:TEMP $env:ChocolateyPackageName)

$InstallerPath = (Get-ChildItem -Path $UnZipPath -filter '*.exe').FullName

# silent install requires AutoHotKey
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkEXE = gci "$env:ChocolateyInstall\lib\autohotkey.portable" -Recurse -filter autohotkey.exe
$ahkProc = Start-Process -FilePath $ahkEXE.FullName -ArgumentList "$ahkFile","$env:ChocolateyPackageFolder" -PassThru
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

