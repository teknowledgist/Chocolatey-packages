$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = 'bluebeamvu'
$DisplayName = 'Bluebeam Vu'
$AppVersion  = '2017.0.40'
$Checksum    = '56a66665722ff56a5fbf5e9c32de36f381c68cb57d8fb4e3661e543cd7cd8bc6'
$URL         = 'https://downloads.bluebeam.com/software/downloads/2017.0.40/vu/BbVu2017.0.40.exe'

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
