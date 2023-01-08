$ErrorActionPreference = 'Stop'

$url      = 'https://polleverywhere-app.s3.amazonaws.com/win-stable/3.0.8/PollEverywhere.PowerPointAddInSetup.msi'
$checksum = '25e7a66adc607bb2f1e20fcdbb442d9b892d216710be8d9cd83dd62ad814655c'

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
