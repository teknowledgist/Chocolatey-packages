$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/a/2/e/a2ea07b5-5a65-41d7-9ac0-b46ac953ab63/PowerBIReportBuilder.msi'
   checksum       = 'dd4f20011bb5f20e627f27a0e2e1a9a0b1d47cd12b15c54378d7a7b7e47d950b'
   checksumType   = 'SHA256'
   fileType       = 'MSI'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

$pp = Get-PackageParameters

if ($pp['Language']) { 
   Write-Host "Language code '$($pp['Language'])' requested." -ForegroundColor Cyan
   $toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
   $Lang = Import-Csv "$toolsDir\LanguageChecksums.csv" | 
               Where-Object {$_.Code -eq $pp['Language']}
   if ($Lang.URL -and $Lang.SHA256) {
      Write-Host "$($Lang.Language) download url and checksum identified." -ForegroundColor Cyan
      $packageArgs.url = $Lang.URL
      $packageArgs.checksum = $Lang.SHA256
   } else {
      Write-Warning "Dowload URL and/or checksum for '$($pp['Language'])' not found!"
      Write-Warning "Default English (US) language will be installed."
   }
} 

Install-ChocolateyPackage @packageArgs
