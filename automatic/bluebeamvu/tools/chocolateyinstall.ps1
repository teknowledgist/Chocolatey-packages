$ErrorActionPreference = 'Stop'  # stop on all errors

$PackageName = 'bluebeamvu'
$DisplayName = 'Bluebeam Vu'
$AppVersion  = '2017'
$Checksum    = '8397f8f69fff444185298f1852c33b606d1ab83e09b32e68a69ed3332849bb87'
$URL         = 'https://downloads.bluebeam.com/software/downloads/2017/vu/BbVu2017.exe'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$DisplayName*$AppVersion*"

if ($key) {
   Write-Host "$($key.DisplayName) already installed." -ForegroundColor Cyan
} else {
   $WorkingFolder = Join-Path -Path $env:TEMP -ChildPath $packageName

   $PackageArgs = @{
     PackageName  = $packageName
     FileFullPath = Join-Path $WorkingFolder $URL.Split('/')[-1]
     Url          = $URL
     Checksum     = $Checksum
     ChecksumType = 'sha256'
   }
  
   # Download
   $Download = Get-ChocolateyWebFile @PackageArgs
   # silent install requires AutoHotKey
   & AutoHotKey $(Join-Path $env:ChocolateyPackageFolder 'tools\chocolateyInstall.ahk') $Download
   # Alert Chocolatey if install failed
   if (-not (Get-UninstallRegistryKey -SoftwareName "$DisplayName*$AppVersion")) {
      Throw "Silent install of $DisplayName $AppVersion failed!"
   }
}
