$ErrorActionPreference = 'Stop'

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   URL            = 'https://www.carthagosoft.net/downloads/TwistpadSetup.zip'
   UnzipLocation  = Join-Path $env:TEMP "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
   ChecksumType   = 'sha256'
   Checksum       = '8ff4ca05cb5ad65269672dba2043245c563764bf563b29fc7f387ccce70704fd'
}
Install-ChocolateyZipPackage @UnZipArgs



$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileType       = 'EXE'
   SoftwareName   = "$env:ChocolateyPackageName*"
   File           = (Get-ChildItem $UnZipArgs.UnzipLocation -Filter '*.exe' -Recurse).FullName
   SilentArgs     = '/S'
   ValidExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs 
