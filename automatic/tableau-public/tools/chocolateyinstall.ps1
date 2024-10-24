$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://downloads.tableau.com/public/TableauPublicDesktop-64bit-2024-3-0.exe'
   checksum64    = 'd6efbdb64ce905897020b2da02ef6a57513301c45d8e4c8e90148d9164d20a19'
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
