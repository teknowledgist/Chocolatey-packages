﻿$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = "$env:ChocolateyPackageName*"
   fileType      = 'MSI' 
   url           = 'https://download.pdf24.org/pdf24-creator-11.23.0-x86.msi'
   checksum      = '86F63D19A586C3E46A54BCF9EF75A9565D070C02A7EFC3AEBCA08F99049D7F45'
   url64bit      = 'https://download.pdf24.org/pdf24-creator-11.23.0-x64.msi'
   checksum64    = '474F7DE6ABC32D99DA397356878268DC5B13257B6436E39C27FFF832FB082F46'
   checksumType  = 'sha256'
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

# The PDF24 Service depends on the Print Spooler service so make it is up and running 
#    (Stolen from cutepdf package and thanks to bcurran3.)
try {
   $serviceName = 'Spooler'
   $spoolerService = Get-WmiObject -Class Win32_Service -Property StartMode,State -Filter "Name='$serviceName'"
   if (-not $spoolerService) { 
      Write-Warning "The Print Spooler service must be running for PDF24 to install."
      Throw "Service $serviceName was not found" 
   }
   Write-Warning "Print Spooler service state: $($spoolerService.StartMode) / $($spoolerService.State)"
   if ($spoolerService.StartMode -ne 'Auto' -or $spoolerService.State -ne 'Running') {
      Set-Service $serviceName -StartupType Automatic -Status Running
      Write-Warning 'Print Spooler service now set to: Auto / Running'
   }
} catch {
   Throw "Unexpected error while checking Print Spooler service: $($_.Exception.Message)"
}

$pp = Get-PackageParameters

if ($pp['Updates']) { 
   if ($pp['Updates'] -eq 'auto') {
      Write-Host 'You have opted for PDF24 to automatically update itself.' -ForegroundColor Cyan
      $U = ' UPDATEMODE=0'
   } elseif ($pp['Updates'] -eq 'off') {
      Write-Host 'You have opted for PDF24 to not check for updates.' -ForegroundColor Cyan
      $U = ' UPDATEMODE=2'
   } else {
      Write-Host 'Unrecognized "/Updates" option!  PDF24 will check and notify about updates only.' -ForegroundColor Cyan
   }
}

if ($pp['Icon']) { 
   Write-Host 'You have opted for the Desktop Icon.' -ForegroundColor Cyan
   $I = ''
} else { $I = ' DESKTOPICONS=No' } 

if ($pp['Fax']) { 
   Write-Host 'You have opted to include the FaxPrinter.' -ForegroundColor Cyan
   $F = ''
} else { $F = ' FAXPRINTER=No' } 

if ($pp['Basic']) {
   Write-Host 'You requested to configure the PDF Printer feature only.' -ForegroundColor Cyan
   $RegPath = 'HKLM:\SOFTWARE'
   if (-not (Test-Path "$RegPath\PDF24")) {
      $null = New-Item -Path $RegPath -Name 'PDF24' -Force
   }
   $Properties = @(
      'NoTrayIcon',
      'NoOnlineConverter',
      'NoShellContextMenuExtension',
      'NoOnlinePdfTools',
      'NoCloudPrint',
      'NoEmbeddedBrowser',
      'NoPDF24MailInterface',
      'NoScreenCapture',
      'NoFax',
      'NoFaxProfile',
      'NoMail'
   )
   ForEach ($item in $Properties) {
      $null = New-ItemProperty -Path "$RegPath\PDF24" -Name $item -PropertyType DWORD -Value 1 -Force
   }
}

$InstallArgs.silentArgs = "$($InstallArgs.silentArgs)$I$F$U"

Install-ChocolateyPackage @InstallArgs

