$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   url            = 'https://download.microsoft.com/download/F/F/9/FF945E45-7D61-49DD-B982-C5D93D3FB0CF/PowerBiReportBuilder.en-US.msi'
   checksum       = '771b1726a117b94d358f20113a1c1438c19020ad65ed976fb7b75d4a560ca353'
   checksumType   = 'SHA256'
   fileType       = 'MSI'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

$pp = Get-PackageParameters

if ($pp['Language']) { 
   Write-Host "Language code '$($pp['Language'])' requested." -ForegroundColor Cyan
   $toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
   $Lang = Import-Csv "$toolsDir\LanguageChecksums.csv" -Delimiter '|' | 
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
