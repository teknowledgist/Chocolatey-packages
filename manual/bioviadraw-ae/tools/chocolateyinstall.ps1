$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   SoftwareName   = 'BIOVIA Draw*'
   FileType       = 'exe'
   url            = 'https://3ds-download-eu-west-1.s3.eu-west-1.amazonaws.com/public/BIOVIA/BIOVIA_Draw_2025_AE_32bit/BIOVIA_Draw_2025_AE.exe'
   url64          = 'https://3ds-download-eu-west-1.s3.eu-west-1.amazonaws.com/public/BIOVIA/BIOVIA_Draw_2025_AE_64bit/BIOVIA_Draw_2025_AE.exe'
   Checksum       = '32f965a23a00fc37c0a2e8ab339bd62a40d9c8158ad111856351cbcb1172de70'
   Checksum64     = '73804e5eade52d637ea030bb5a68c8b131e752405db3e762bec7836c74173aa0'
   ChecksumType   = 'sha256'
   silentArgs     = "/s /v`"/qn /norestart /l*v $($ShortTemp)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0,3010)  
}

Install-ChocolateyPackage @InstallArgs
