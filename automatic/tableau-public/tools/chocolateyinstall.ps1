$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url64bit      = 'https://public.tableau.com/s/download/public/pc64'
   checksum64    = 'baabe50eb4204d7675f66051aa4e4222de2b2b20572c01b13795a8c3d636380e'
   checksumType  = 'sha256'
   silentArgs    = "/quiet /norestart /LOG `"$($env:TEMP)\TableauPublic-$($env:chocolateyPackageVersion)-InstallLogs\Install.log`" ACCEPTEULA=1"
   validExitCodes= @(0,3010)
}

Install-ChocolateyPackage @packageArgs
