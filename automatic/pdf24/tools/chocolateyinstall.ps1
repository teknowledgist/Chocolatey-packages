$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Installer = (Get-ChildItem $toolsDir -Filter '*.msi').FullName

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'MSI' 
   File          = $Installer
   softwareName  = "$env:ChocolateyPackageName*"
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

$pp = Get-PackageParameters

if (!$pp['DesktopIcon']) { $I = ' DESKTOPICONS=No' } 
else { 
   Write-Host 'You have opted for the Desktop Icon.' -ForegroundColor Cyan
   $I = ''
}

if (!$pp['PrintOnly']) {
   $F = ''
} else {
   Write-Host 'You requested to configure the PDF Printer feature only.' -ForegroundColor Cyan
   $F = ' FAXPRINTER=No'
   $RegPath = 'HKLM:\SOFTWARE\Wow6432Node'
   if (-not (Test-Path "$RegPath\PDFPrint")) {
      $null = New-Item -Path $RegPath -Name 'PDFPrint' -Force
   }
   $Properties = @(
      "NoTrayIcon",
      "NoOnlineConverter",
      "NoShellContextMenuExtension",
      "NoOnlinePdfTools",
      "NoCloudPrint",
      "NoEmbeddedBrowser",
      "NoPDF24MailInterface",
      "NoScreenCapture",
      "NoFax",
      "NoFaxProfile",
      "NoMail"
   )
   ForEach ($item in $Properties) {
      $null = New-ItemProperty -Path "$RegPath\PDFPrint" -Name $item -PropertyType DWORD -Value 1 -Force
   }
}

$InstallArgs.silentArgs = "$($InstallArgs.silentArgs)$I$F"

Install-ChocolateyInstallPackage @InstallArgs

