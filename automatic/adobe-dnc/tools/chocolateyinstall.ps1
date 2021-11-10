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
   url64bit       = 'ftp://ftp.adobe.com/pub/adobe/dng/win/AdobeDNGConverter_x64_14_0.exe'
   checksum64     = 'a2b14beac45b1b0d51527c6a7738256ee486b40ccc6a0ba10764bd8ab34a2579'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
