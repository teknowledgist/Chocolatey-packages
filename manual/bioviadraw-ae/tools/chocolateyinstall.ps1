$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   SoftwareName   = 'BIOVIA Draw*'
   FileType       = 'exe'
   url            = 'https://3ds-download-eu-west-1.s3.eu-west-1.amazonaws.com/public/BIOVIA/BIOVIA_Draw_2024_AE_32bit.exe'
   url64          = 'https://3ds-download-eu-west-1.s3.eu-west-1.amazonaws.com/public/BIOVIA/BIOVIA_Draw_2024_AE_64bit.exe'
   Checksum       = '7e6b4527835b153d40f7b6e205522edde318326ed6b6c51228ede3b5376a2bd6'
   Checksum64     = '0f7a9ca41faa5abf6c41d7fd753b6e51bb84495c208904489a13ee8c3c8fecb6'
   ChecksumType   = 'sha256'
   silentArgs     = "/s /v`"/qn /norestart /l*v $($ShortTemp)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0,3010)  
}

Install-ChocolateyPackage @InstallArgs
