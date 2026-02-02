$ErrorActionPreference = 'Stop'

$x86URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.3.0/Thorium.Setup.3.3.0.exe'
$x86Checksum = 'ac1a60804fbe98dc76a0cf73de6c49c3a2dc283d0866597b1acb600ccb775eb4'
$ARM64URL = 'https://github.com/edrlab/thorium-reader/releases/download/v3.3.0/Thorium.Setup.3.3.0-arm64.exe'
$ARM64Checksum = '3d119cfb044550b8a9e01053e820bd57d8c89754063c82989c7146a18e1b177a'

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

