$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/a/2/e/a2ea07b5-5a65-41d7-9ac0-b46ac953ab63/PowerBIReportBuilder.msi'
   checksum       = '46454fc85c9125afeefcb2c9316aa23dee6c995fa8b5d27a11de24f5d1b71826'
   checksumType   = 'SHA256'
   fileType       = 'MSI'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
