$ErrorActionPreference = 'Stop'

$url        = 'https://librarytools.com/downloads/LCEasy4.msi' 
$url64      = 'https://librarytools.com/downloads/LCEasy4x64.msi' 
$Checksum   = 'e8389d0798d95e02876e6d08d0695d3ad0a7180968022e49af20df182bd78e16'
$Checksum64 = 'f0274bc96bf06beb30a381445f73c139f82cc9ebdda234660b4bc6687115dce6'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'LC Easy*'
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  checksum      = $Checksum
  checksum64    = $Checksum64
  checksumType  = 'sha256'
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" INSTALLDESKTOPSHORTCUT=0"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
