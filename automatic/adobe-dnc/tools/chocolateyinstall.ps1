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
   url64bit       = 'https://download.adobe.com/pub/adobe/dng/win/AdobeDNGConverter_x64_15_2.exe'
   checksum64     = 'f22778a5337ce220ebef9f5acadac3dfe718805042425c18e93154e485e35a03'
   checksumType64 = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
