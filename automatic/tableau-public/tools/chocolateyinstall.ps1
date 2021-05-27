$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://downloads.tableau.com/public/TableauPublicDesktop-64bit-2021-1-2.exe'
   checksum64    = 'b05468d697d458bad5fe05c9a45bf832ec4b8f948e7677671e966a577c923974'
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
