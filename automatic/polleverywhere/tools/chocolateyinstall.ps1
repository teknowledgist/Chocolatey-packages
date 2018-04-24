$ErrorActionPreference = 'Stop'

$url      = 'https://polleverywhere-app.s3.amazonaws.com/win-stable/2.3.1/PollEverywhere.PowerPointAddInSetup.msi'
$checksum = '8c4e54d3629e57b21fd31ea8d14b71aa7e72c165b0ab2158809606653f27d970'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = $url
   softwareName  = 'Poll Everywhere*'
   checksum      = $checksum
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
