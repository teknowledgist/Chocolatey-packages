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
   checksum      = '1b7785a908897955080bcabecb38ac6cf91869f5489d06363033b80620dfeaca'
   checksum64    = 'BAA094A7FF84C11FA5E6BAC3C626037F6AA8BFE4E027EB75930B33BE51F768BB'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

# Check for ARM64 processor
$Features = Get-ProcessorFeatures
if ($Features.'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $ARM64Checksum = '6DBC155D96007B56356069060874A8E946F86D428364C2F8A947BFB95E05A93F'
   $packageArgs.url64 = $ARM64URL
   $packageArgs.checksum64 = $ARM64Checksum
}

Install-ChocolateyPackage @InstallArgs
