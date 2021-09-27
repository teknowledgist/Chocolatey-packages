$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://downloads.tableau.com/public/TableauPublicDesktop-64bit-2021-3-1.exe'
   checksum64    = 'f07cf5a0ae44bd2f184ac5d3ccc5494031a5186a73b16547df4c643e12d63f30'
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
