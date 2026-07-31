$ErrorActionPreference = 'Stop'

if ((Get-ProcessorBits) -ne '64') {
   Throw 'This package requires a 64-bit processor!'
}

$x64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/29459/download?i_agree_to_tenable_license_agreement=true'
$x64Checksum = 'e703d33f121e5b8258f775e96760f4ae37a675e10fafb9fa86fc25d6828479ac'
$ARM64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/29460/download?i_agree_to_tenable_license_agreement=true'
$ARM64Checksum = 'e703d33f121e5b8258f775e96760f4ae37a675e10fafb9fa86fc25d6828479ac'

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
