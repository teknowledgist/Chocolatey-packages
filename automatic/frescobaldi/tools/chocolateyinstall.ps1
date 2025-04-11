$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'msi'
   url            = 'https://github.com/frescobaldi/frescobaldi/releases/download/v4.0.1/Frescobaldi-4.0.1.msi'
   Checksum       = '8d99b1850ff39667746476a740fba60c2dce9e5900ef190ede8ec5cf9161562e'
   ChecksumType   = 'sha256'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
