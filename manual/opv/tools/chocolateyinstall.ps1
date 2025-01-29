$ErrorActionPreference = 'Stop'

$params = @{
   PackageName   = 'opv'
   FileType      = 'exe'
   Url           = 'https://onephotoviewer.com/downloads/OPV_Setup_v1-18-1-0.exe'
   Checksum      = 'db71815802b4dc048fce49135b4b47f4545aa807f511261f780d6a6f001ed20d'
   ChecksumType  = "sha256"
   silentArgs    = "/S"
   validExitCodes= @(0)
} 
Install-ChocolateyPackage @params
