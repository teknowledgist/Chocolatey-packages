$ErrorActionPreference = 'Stop'  # stop on all errors

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   url           = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup32Admin.msi'
   url64         = 'https://marcedit.reeset.net/software/marcedit7/MarcEdit_Setup64Admin.msi'
   checksum      = '8A96D9F3D9CCBCA2A885D3E1B52A7312549BBBD62DBC6D7D66E3B4958E1E8073'
   checksum64    = '886EE4FC55D18A464A8672746108CA86F4F71A7184EE68DDBD22FAD78FCDFAED'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs 
