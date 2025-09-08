$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'msi'
   url            = 'https://github.com/frescobaldi/frescobaldi/releases/download/v4.0.4/Frescobaldi-4.0.4.msi'
   Checksum       = '596937154057e48612b25f9d3ce3cba98d0c56dcd715d330baefe63f3b501556'
   ChecksumType   = 'sha256'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
