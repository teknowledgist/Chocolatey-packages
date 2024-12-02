$ErrorActionPreference = 'Stop'

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   URL            = 'https://www.carthagosoft.net/downloads/TwistpadSetup.zip'
   UnzipLocation  = Join-Path $env:TEMP "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
   ChecksumType   = 'sha256'
   Checksum       = '732a30a080168e23489fc0ee14236298583cd9d84018b4c63130d4a4aa35899a'
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
