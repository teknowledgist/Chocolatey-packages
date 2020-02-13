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
   url           = $fileLocation | Where-Object {$_.FullName -notmatch 'x64'} | Select-Object -ExpandProperty FullName
   url64bit      = $fileLocation | Where-Object {$_.FullName -match 'x64'} | Select-Object -ExpandProperty FullName
   <#
         checksum      = 'DA906F87D5023A0D51ED3AB34B0211274DD71CB1AC1B72418EDAEBF7D0573573'
         checksum64    = 'EFDCAA5107C188371F43BEBDEACB3D0943B20C6804CE49E7EAFB943033DA42E3'
   #>
   silentArgs    = "-q -platform $BitLevel$HostSwitch -upg -v PROP_REBOOT=0 -v PROP_SHORTCUTS=0"
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
New-Item "$fileLocation.ignore" -Type file -Force | Out-Null
