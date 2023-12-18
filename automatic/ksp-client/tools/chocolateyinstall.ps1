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
   checksum      = 'a05b460872316f6e32c7801c7ac840dbc533b78a8748f4031df99fae0c6c2c26'
   checksum64    = '51ee1826421d8f2b7a875a6cd644198239a8d987c6bb30840d57fbb5967c9ffe'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
