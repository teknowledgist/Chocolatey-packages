$ErrorActionPreference = 'Stop'

Write-Warning "Adobe DNG Converter requires Windows 10, release 22H2 or newer."
$22H2Build = 19045
$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, BuildNumber, Caption, ReleaseID
$osInfo.Version = [version]$osInfo.Version
$osInfo.ReleaseID = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseID).ReleaseID

Write-host "Detected:  $($osInfo.Caption), Release $($osInfo.ReleaseID)" -ForegroundColor Cyan

If (($osInfo.Version.Major -ne 10) -or ($osInfo.BuildNumber -lt $22H2Build) -or ($osInfo.Caption -match 'ltsc')) {
   Throw "$($osInfo.Caption), Release $($osInfo.ReleaseID) is not compatible with Adobe DNG Converter!"
}

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'DNGConverter*'
   fileType       = 'EXE'
   url64bit       = 'https://download.adobe.com/pub/adobe/dng/win/AdobeDNGConverter_x64_17_3.exe'
   checksum64     = '2895eca70d49d8d278e83ac1f08923d6fff54e2c5c3720f45be26c7b28cb7627'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
