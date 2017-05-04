$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = 'bluebeamvu'
$DisplayName = 'Bluebeam Vu'
$AppVersion  = '2017.0'
$Checksum    = '8397f8f69fff444185298f1852c33b606d1ab83e09b32e68a69ed3332849bb87'
$URL         = 'https://downloads.bluebeam.com/software/downloads/2017/vu/BbVu2017.exe'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$DisplayName*$AppVersion*"

if ($AppVersion -like "*$($key.DisplayVersion)") {
   Write-Host "$($key.DisplayName) v$AppVersion already installed." -ForegroundColor Cyan
} else {
   $WorkingFolder = Join-Path -Path $env:TEMP -ChildPath $packageName

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
