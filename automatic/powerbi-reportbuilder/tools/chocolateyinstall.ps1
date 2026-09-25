$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/a/2/e/a2ea07b5-5a65-41d7-9ac0-b46ac953ab63/PowerBIReportBuilder.msi'
   checksum       = 'b50c46d037e49868e6cfc20c2bb91fd929105211ac7f5bcf6910d2a89293eaad'
   checksumType   = 'SHA256'
   fileType       = 'MSI'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
