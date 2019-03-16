$ErrorActionPreference = 'Stop'  # stop on all errors

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   url           = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup32Admin.msi'
   url64         = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup64Admin.msi'
   checksum      = '9cfc28e3c34399ccedd0a72b7b80281a30c7651858c64f82fd2f7f7e623dc3ab'
   checksum64    = '5b862efeb35403efc08d1d791aac89e8e648a5c0f8f8de881c91c0ff22a58e76'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
