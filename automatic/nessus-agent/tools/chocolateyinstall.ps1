$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/15493/download?i_agree_to_tenable_license_agreement=true'
   url64bit      = 'https://www.tenable.com/downloads/api/v1/public/pages/nessus-agents/downloads/15492/download?i_agree_to_tenable_license_agreement=true'
   softwareName  = 'Nessus Agent*'
   checksum      = '2cc69d64bbd98028863e3df1bec4a65a1f0effe2d7269d03cc84796b53dd42c0'
   checksum64    = '22bb3c8cc0b952be5661f0ac1593bf1ccf597d74a3abf0c6150bf82fd3db3193'
   checksumType  = 'sha256' 
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($Env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" "
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
