$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'EXE'
   url           = 'https://harzing.com/download/PoP8Setup.exe'
   checksum      = '2e76e7677972cd02596456b95cb05964c30890a85a220753b68cbc64643bf7bb'
   checksumType  = 'sha256'
   silentArgs    = "/a /q2 /b0 /log:`"$($env:TEMP)\PublishOrPerish-$($env:chocolateyPackageVersion)-Install.log`""
   validExitCodes= @(0,12)
}

Install-ChocolateyPackage @packageArgs
