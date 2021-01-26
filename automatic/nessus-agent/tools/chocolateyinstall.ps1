$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/12160/download?i_agree_to_tenable_license_agreement=true'
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/12159/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
   checksum      = 'f53d7deefd661476be57092b28accc7412ce792b7fa84e6b2fdd58a4907624d7'
   checksum64    = '4c111c11de5230af57b9de310fdd91f13555f33a4b0afdb96378e1ac774ef058'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
