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
   $DownloadServer = 'https://www.sassafras.com/links'
   $CondensedVersion = ([version]$env:ChocolateyPackageVersion).tostring(2).replace('.','') + '-latest'
} else {
   $DownloadServer = "https://$($pp['Source'])"
   $CondensedVersion = $env:ChocolateyPackageVersion.replace('.','')
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Sassafras Keyserver Platform Client*'
   fileType      = 'EXE'
   url           = "$DownloadServer/ksp-client-i386-$CondensedVersion.exe"
   url64bit      = "$DownloadServer/ksp-client-x64-$CondensedVersion.exe"
   checksum      = '552ec94860123857a89384dd27e0db95989d60b1f119060fe6dd15f85d3d6b60'
   checksum64    = '8caeb8e06c148daf926fe70a0a9f44768d6c25208c56d3aa2b0a3a53aa345488'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
