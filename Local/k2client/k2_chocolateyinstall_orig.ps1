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
         checksum      = 'EFDFA9CC82BA29FD11A4E9E3D5DA39287F46E0E7B51C5B579B9793B8C19AF893'
         checksum64    = 'CA6A8D3B68765115F7754EB883577BA09C8C4998DC487D2C3A1A380CF2BE3CF4'
   #>
   silentArgs    = "-q -platform $BitLevel$HostSwitch -upg -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
foreach ($item in $fileLocation) {
   $null = Remove-Item $item.fullname -Force
}
