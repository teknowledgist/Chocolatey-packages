﻿$ErrorActionPreference = 'Stop'

Write-Warning "Adobe DNG Converter requires Windows 10, release 1809 or newer."
$1809Build = 17763
$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, BuildNumber, Caption, ReleaseID
$osInfo.Version = [version]$osInfo.Version
$osInfo.ReleaseID = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseID).ReleaseID

Write-host "Detected:  $($osInfo.Caption), Release $($osInfo.ReleaseID)" -ForegroundColor Cyan

If (($osInfo.Version.Major -ne 10) -or ($osInfo.BuildNumber -lt $1809Build) -or ($osInfo.Caption -match 'ltsc')) {
   Throw "$($osInfo.Caption), Release $($osInfo.ReleaseID) is not compatible with Adobe DNG Converter!"
}

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'DNGConverter*'
   fileType       = 'EXE'
   url64bit       = 'https://download.adobe.com/pub/adobe/dng/win/AdobeDNGConverter_x64_16_2.exe'
   checksum64     = 'c985f1f4ac43297a4877f23a9fb8d5bc40b378f187bbcf29704a71a9e412566a'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
