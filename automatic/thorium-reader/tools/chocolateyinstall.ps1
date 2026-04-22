$ErrorActionPreference = 'Stop'

$x86URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.4.0/Thorium.Setup.3.4.0.exe'
$x86Checksum = '4f8eb97e3572602f27372125e300246db2cf9281f670b0f844b853c9c1340b67'
$ARM64URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.4.0/Thorium.Setup.3.4.0-arm64.exe'
$ARM64Checksum = '99f2ebc3db4c4f416157d456427ee2d0b545cbb2fb0aaccb31966ddf2abe8273'

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

