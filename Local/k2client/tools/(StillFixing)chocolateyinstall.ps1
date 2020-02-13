$ErrorActionPreference = 'Stop'

$BitLevel = Get-ProcessorBits

$pp = Get-PackageParameters

if ($pp['Host']) {
   Write-Host "You have requested to use KeyServer: $($pp['Host'])" -ForegroundColor Cyan
   $HostSwitch = " -v PROP_HOSTNAME=$($pp['Host'])" 
   if (!$pp['Source']) {
      $DownloadServer = "https://$($pp['Host'])/site"
      $Options = @{ Headers = @{ 'ContentType' = 'application/octet-stream'; } }
   }
} else {
   $DownloadServer = 'https://www.sassafras.com/links'
}
if ($pp['Source']) {
   if ($pp['Source'] -eq 'Sassafras') {
      $DownloadServer = 'https://www.sassafras.com/links'
   } else {
      $DownloadServer = "https://$($pp['Source'])"
   }
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'K2Client*'
   fileType      = 'EXE'
   url           = "$DownloadServer/K2Client.exe"
   url64bit      = "$DownloadServer/K2Client-x64.exe"
   checksum      = 'da906f87d5023a0d51ed3ab34b0211274dd71cb1ac1b72418edaebf7d0573573'
   checksum64    = 'efdcaa5107c188371f43bebdeacb3d0943b20c6804ce49e7eafb943033da42e3'
   silentArgs    = "-q -platform $BitLevel$HostSwitch -upg -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   options       = @{ Headers = @{ 'ContentType' = 'application/octet-stream'; }}
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
