$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = 'bluebeamvu'
$DisplayName = 'Bluebeam Vu'
$AppVersion  = '2017.0.30'
$Checksum    = '632d98bb4a45c0c26a50f2396a9271d619329b29acbdcf8982fd965a83f64c9c'
$URL         = 'https://downloads.bluebeam.com/software/downloads/2017.0.30/vu/BbVu2017.0.30.exe'

$uninstallEntry = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$DisplayName $AppVersion*"
$uninstallEntryWow64 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$DisplayName $AppVersion*"

if ((Test-Path $uninstallEntry) -or (Test-Path $uninstallEntryWow64)) {
   Write-Host "$($key.DisplayName) v$AppVersion already installed." -ForegroundColor Cyan
} else {
   $PackageArgs = @{
     PackageName  = $packageName
     fileType     = 'exe'
     Url          = $URL
     Checksum     = $Checksum
     ChecksumType = 'sha256'
   }
  
   # silent install requires AutoHotKey
   $ahkExe = 'AutoHotKey'
   $ahkFile = Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'chocolateyInstall.ahk'
   $ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "$ahkFile" -PassThru
   $ahkId = $ahkProc.Id
   Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
   Write-Debug "Process ID:`t$ahkId"
   
   Install-ChocolateyPackage @PackageArgs
}
