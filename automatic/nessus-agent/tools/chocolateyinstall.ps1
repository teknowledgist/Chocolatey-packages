$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
#   url           = ''
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/27519/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
#   checksum      = ''
   checksum64    = 'badf73155ca4528a7964f0a5776249db694dee141220c048f83406bd7c8d03a2'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
