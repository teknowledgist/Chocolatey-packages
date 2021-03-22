$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/12555/download?i_agree_to_tenable_license_agreement=true'
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/12554/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
   checksum      = 'f1b959c182529f78c9566bf4549eaf3afdf9cb07793edc9b69234431c57e05b4'
   checksum64    = '54d4f40e22b1fa4884d80e5846d13b5dc1da7bcb7f3588d2dac1ea4336911923'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
