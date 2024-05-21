$ErrorActionPreference = 'Stop'

$installArgs = @{
   packageName = 'jana2006'
   installerType = 'msi'
   url = 'http://www-xray.fzu.cz/jana/download/stable2006/janainst.msi'
   checkSum = '354ebf1c7c1440fc20501b4e39e6305980a108d87a085e1f1f0c15c26902c50f'
   checkSumType = 'sha256'
   silentArgs = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0,3010)
}

Install-ChocolateyPackage @installArgs