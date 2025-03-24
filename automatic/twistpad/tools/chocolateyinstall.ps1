$ErrorActionPreference = 'Stop'

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   URL            = 'https://www.carthagosoft.net/downloads/TwistpadSetup.zip'
   UnzipLocation  = Join-Path $env:TEMP "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
   ChecksumType   = 'sha256'
   Checksum       = 'a05026c235e422ee2c8ea4b3752fe95b7e623e769db0204d28ce584d5f0aa5de'
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
