﻿$ErrorActionPreference = 'Stop'

$url      = 'https://polleverywhere-app.s3.amazonaws.com/win-stable/4.2.2/PollEverywhere.PowerPointAddInSetup.msi'
$checksum = '753425b7b7560e86a3a36292faaef24f0f729e1788ce09c0c86411fa38d8ea0d'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI'
   url           = $url
   softwareName  = 'Poll Everywhere*'
   checksum      = $checksum
   checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
