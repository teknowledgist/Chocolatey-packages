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
   checksum      = '2d34cda4d797816862d6b17752510d191d56eda49069b84afdbb412b8a2f728b'
   checksum64    = '280e8990d4cf2a55b23ff76bb65f5667de39b4e782ff311bfcfefa917015ffe5'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

# Check for ARM64 processor
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $ARM64Checksum = '2d67e64051231e036ec60f42b9e4a901d45261e6fa4f871a2f1027a403b832d9'
   $packageArgs.url64 = $ARM64URL
   $packageArgs.checksum64 = $ARM64Checksum
}

Install-ChocolateyPackage @InstallArgs
