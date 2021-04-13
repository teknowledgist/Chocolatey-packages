$ErrorActionPreference = 'Stop'

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
   url64bit       = 'ftp://ftp.adobe.com/pub/adobe/dng/win/DNGConverter_13_1.exe'
   checksum64     = '6472582bbf4d2026fb971c202c9551d001a245c6273add423fcda064b424902e'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
