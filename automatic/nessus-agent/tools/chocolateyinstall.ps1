$ErrorActionPreference = 'Stop'

if ((Get-ProcessorBits) -ne '64') {
   Throw 'This package requires a 64-bit processor!'
}

$x64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/29854/download?i_agree_to_tenable_license_agreement=true'
$x64Checksum = '80562755f498a2820b224e229a21203689a398981a0c771e29da1eba4cccba35'
$ARM64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/29855/download?i_agree_to_tenable_license_agreement=true'
$ARM64Checksum = '80562755f498a2820b224e229a21203689a398981a0c771e29da1eba4cccba35'

# Check for ARM64 processor
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $URL = $ARM64URL
   $Checksum = $ARM64Checksum
}
else {
   $URL = $x64URL
   $Checksum = $x64Checksum
}


$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url64bit      = $URL
   softwareName  = 'Nessus Agent*'
   checksum64    = $Checksum
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
