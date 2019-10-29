$ErrorActionPreference = 'Stop'

$url      = 'https://polleverywhere-app.s3.amazonaws.com/win-stable/2.12.0/PollEverywhere.PowerPointAddInSetup.msi'
$checksum = '13c8e785752f536119328fcd80807a642505ce3602665f7f49833a0000ba4843'

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
