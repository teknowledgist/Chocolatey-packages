$ErrorActionPreference = 'Stop'

$URL_x86 = 'https://download.zotero.org/client/release/10.0.8/Zotero-10.0.8_win32_setup.exe'
$SHA_x86 = '69018A0EAC1F01A4E474D395AF96E36DA12FBD57EE82ECA31327E13BC9DD8105'
$URL_x64 = 'https://download.zotero.org/client/release/10.0.8/Zotero-10.0.8_x64_setup.exe'
$SHA_x64 = '1BA5D091FD24B50DB1159C71650F55303D99C82E66494DC09EDDAB76A4179D73'
$URL_ARM64 = 'https://download.zotero.org/client/release/10.0.8/Zotero-10.0.8_arm64_setup.exe'
$SHA_ARM64 = '8AC06A4C05F995CA1B67202D3327876E9119F9E38A1BA366FCBB57A9DD87D8A5'

$packageArgs = @{
   packageName    = $env:chocolateyPackageName
   softwareName   = "Zotero*"
   fileType       = 'exe'
   url            = $URL_x86
   url64          = $URL_x64
   checksum       = $SHA_x86
   checksum64     = $SHA_x64
   checksumType   = 'sha256'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

# Check for ARM64 processor. 
if ((Get-ProcessorFeatures).'ARM_V8_INSTRUCTIONS') {
   Write-Verbose 'ARM processor found.  Installing ARM64 build.'
   # Chocolatey uses the x86 installer for ARM64 installs. See: https://github.com/chocolatey/choco/issues/1800
   $PackageArgs.url = $URL_ARM64
   $PackageArgs.Checksum = $SHA_ARM64
}

Install-ChocolateyPackage @packageArgs
