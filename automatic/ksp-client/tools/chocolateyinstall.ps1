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
   checksum      = '02f90b8a107027ad1c71faca5362f7de7210f567be8788afc8a9ecf4f786e8a0'
   checksum64    = '89DBE302438FE861D9EA40345846DC4FDFAA93B0A392F821245C3BC765C84B2A'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ($Features.'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $ARM64Checksum = '00C9FC3224133B027FE0AFF97E1E25B922AB7F7FCCB6D3B69148F1E2146161E9'
   $packageArgs.url64 = $ARM64URL
   $packageArgs.checksum64 = $ARM64Checksum
}

Install-ChocolateyPackage @InstallArgs
