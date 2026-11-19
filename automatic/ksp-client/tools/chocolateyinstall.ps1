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
   checksum      = '93a762f2e607c4f0de493baa32210238c9d7e70284fee7efa0848de5cb83818b'
   checksum64    = '81A8952FA54E38858D332DD094CBA164D8A1CB9CE3DB79DB4536FB686E419E19'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ($Features.'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $ARM64Checksum = '840237B4BE9C2C68D25528B8C4047955773E722C7B48B16F98CC5DD7F446190B'
   $packageArgs.url64 = $ARM64URL
   $packageArgs.checksum64 = $ARM64Checksum
}

Install-ChocolateyPackage @InstallArgs
