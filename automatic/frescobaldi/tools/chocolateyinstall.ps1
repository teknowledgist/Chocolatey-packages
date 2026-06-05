$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'msi'
   url            = 'https://github.com/frescobaldi/frescobaldi/releases/download/v4.0.7/Frescobaldi-4.0.7.msi'
   Checksum       = '600257774c74671539cd61b4388d98bd24c5e0c8b6effc520d17699ed17e9889'
   ChecksumType   = 'sha256'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
