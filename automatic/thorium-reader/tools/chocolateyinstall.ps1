$ErrorActionPreference = 'Stop'

$x86URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.5.1/Thorium-3.5.1-x64.exe'
$x86Checksum = 'ad33003c0648b8f8f91cb9368b457701f23b1ed9443b01c94934f756f7ed98fd'
$ARM64URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.5.1/Thorium-3.5.1-arm64.exe'
$ARM64Checksum = 'e5d6aad57490dd68fc117cc02f172a6d86cf6777f91689dd710594b0c0fb1d8f'

# Check for ARM64 processor
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Downloading ARM64 build.'
   $URL = $ARM64URL
   $Checksum = $ARM64Checksum
} else {
   $URL = $x86URL
   $Checksum = $x86Checksum
}

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   URL            = $URL
   Checksum       = $Checksum
   ChecksumType   = 'SHA256'
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs      = '/S /ALLUSERS'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

