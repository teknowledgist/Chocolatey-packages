$ErrorActionPreference = 'Stop'

if ((Get-ProcessorBits) -ne '64') {
   Throw 'This package requires a 64-bit processor!'
}

$x64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/27830/download?i_agree_to_tenable_license_agreement=true'
$x64Checksum = '5a5e8a496098daf0a044885264d2eb78020abe4846fe9cbca21c56c4a627ce92'
$ARM64URL = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/27831/download?i_agree_to_tenable_license_agreement=true'
$ARM64Checksum = '5a5e8a496098daf0a044885264d2eb78020abe4846fe9cbca21c56c4a627ce92'

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
