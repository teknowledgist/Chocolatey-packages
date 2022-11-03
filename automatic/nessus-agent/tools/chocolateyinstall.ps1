$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/17739/download?i_agree_to_tenable_license_agreement=true'
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/17738/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
   checksum      = '62143ab255099f105434cf11bb311d663fce667b55109229f875fa2859e7746f'
   checksum64    = 'e59a4f3506f77b1ecdde7f92d287fa79368298146ac7487638ceb27056d6e144'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
