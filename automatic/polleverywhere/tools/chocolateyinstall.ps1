$ErrorActionPreference = 'Stop'

$url      = 'https://polleverywhere-app.s3.amazonaws.com/win-stable/2.16.0/PollEverywhere.PowerPointAddInSetup.msi'
$checksum = 'ea558a057a517cf192d23f2d1750e3d0ab0a5fa9f9127fa621f4a0fbae28b03c'

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
