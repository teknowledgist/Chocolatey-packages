$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   installerType  = 'msi'
   url            = 'https://github.com/frescobaldi/frescobaldi/releases/download/v4.0.2/Frescobaldi-4.0.2.msi'
   Checksum       = '1f21e85d4342549ef7395ab8bf350bb03d395cdd4cc8758d83dbb9e7b4e7ecce'
   ChecksumType   = 'sha256'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs
