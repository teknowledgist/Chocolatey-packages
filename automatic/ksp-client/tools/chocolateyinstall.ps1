﻿$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$pp = Get-PackageParameters

if (!$pp['Host']) {
   Write-Warning 'The KSP client is useless without a host!  You will have to run KeyAccess to add it later.'
} else {
   Write-Host "You have requested to use KeyServer: $($pp['Host'])" -ForegroundColor Cyan
   $HostSwitch = "-v PROP_HOSTNAME=$($pp['Host'])" 
}

if (!$pp['Source']) {
   $DownloadServer = 'https://www.sassafras.com/software/release/current/Installers/Windows/client'
} else {
   $CondensedVersion = '-' + $env:ChocolateyPackageVersion.replace('.','')
   $DownloadServer = "https://$($pp['Source'])"
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Sassafras Keyserver Platform Client*'
   fileType      = 'EXE'
   url           = "$DownloadServer/ksp-client-i386$CondensedVersion.exe"
   url64bit      = "$DownloadServer/ksp-client-x64$CondensedVersion.exe"
   checksum      = ''
   checksum64    = ''
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
