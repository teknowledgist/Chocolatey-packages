$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/24279/download?i_agree_to_tenable_license_agreement=true'
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/24278/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
   checksum      = '70f7a9e0cce07a562f819e4750ede7a8a8d992882fd6e603639fe71152a62f2b'
   checksum64    = 'eadc636c8fd3f1686212413f1491eae2d1024defbe3494e00f812e0d1e532ca8'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
