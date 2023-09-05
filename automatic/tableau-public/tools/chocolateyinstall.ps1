$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://public.tableau.com/s/download/public/pc64'
   checksum64    = '8e007c3d3258db8b4521e24a5adcd6d5693d2a56b72c192ac079d90ad5ed5084'
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
