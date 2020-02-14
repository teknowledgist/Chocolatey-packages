$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = Get-ChildItem -Path $toolsDir -Filter '*.exe'

$BitLevel = Get-ProcessorBits
$pp = Get-PackageParameters

if ($pp['Host']) {
   Write-Host "You have requested to use KeyServer: $($pp['Host'])" -ForegroundColor Cyan
   $HostSwitch = " -v PROP_HOSTNAME=$($pp['Host'])" 
}

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'K2Client*'
   fileType      = 'EXE'
   File          = $fileLocation | Where-Object {$_.FullName -notmatch 'x64'} | Select-Object -ExpandProperty FullName
   File64        = $fileLocation | Where-Object {$_.FullName -match 'x64'} | Select-Object -ExpandProperty FullName
   <#
         checksum      = 'da906f87d5023a0d51ed3ab34b0211274dd71cb1ac1b72418edaebf7d0573573'
         checksum64    = 'efdcaa5107c188371f43bebdeacb3d0943b20c6804ce49e7eafb943033da42e3'
   #>
   silentArgs    = "-q -platform $BitLevel$HostSwitch -upg -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
foreach ($item in $fileLocation) {
   $null = Remove-Item $item.fullname -Force
}
