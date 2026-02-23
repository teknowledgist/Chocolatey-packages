$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'msi'
   url            = 'https://github.com/frescobaldi/frescobaldi/releases/download/v4.0.5/Frescobaldi-4.0.5.msi'
   Checksum       = 'd02ffcee1b25aa2a7657eb962c1fb9f028e5414f36b5b22eb180e6ee2095b669'
   ChecksumType   = 'sha256'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
