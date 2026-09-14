$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$pp = Get-PackageParameters

if (!$pp['Host']) {
   Write-Warning 'The KSP client is useless without a host!  You will have to run KeyAccess to add it later.'
} else {
   Write-Host "You have requested to use KeyServer: $($pp['Host'])" -ForegroundColor Cyan
   $HostSwitch = "-v PROP_HOSTNAME=$($pp['Host'])" 
}

if (!$pp['Source']) {
   $URL = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-i386.exe'
   $URL64 = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-x64.exe'
   $ARM64URL = 'https://download.sassafras.com/software/release/current/Installers/Windows/Client/ksp-client-arm64.exe'
} else {
   $DownloadServer = "https://$($pp['Source'])"
   $CondensedVersion = $env:ChocolateyPackageVersion.replace('.','')
   $URL = "$DownloadServer/ksp-client-i386-$CondensedVersion.exe"
   $URL64 = "$DownloadServer/ksp-client-x64-$CondensedVersion.exe"
   $ARM64URL = "$DownloadServer/ksp-client-arm64-$CondensedVersion.exe"
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Sassafras Keyserver Platform Client*'
   fileType      = 'EXE'
   url           = $URL
   url64bit      = $URL64
   checksum      = '4438de311c918b73368544762d43fa76d74621f05e108737edf10ed108ac47ea'
   checksum64    = '206360ED354867DFAFC28CCB85519C413384DE870E95AC156415A789C510A001'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ($Features.'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $ARM64Checksum = '02B2128A1026634C2EE74157E912DCF9A8A241E9626BAEC31E535837CFA4FEE1'
   $packageArgs.url64 = $ARM64URL
   $packageArgs.checksum64 = $ARM64Checksum
}

Install-ChocolateyPackage @InstallArgs
