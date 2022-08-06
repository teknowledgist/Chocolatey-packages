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
   checksum      = '77b4c5e6f7db65991fd8439a4b50ebe9ae2b4e3d8459183896a2355ecd7b2388'
   checksum64    = 'dce96128f5b94a7be5b30d0fc7704f4d666655a95d4664b9a3a4b492e3ffdb14'
   checksumType  = 'sha256'
   silentArgs    = "-q -platform $BitLevel -upg $HostSwitch -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
