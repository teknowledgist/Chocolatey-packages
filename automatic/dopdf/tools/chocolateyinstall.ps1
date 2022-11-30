$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters

$DownloadArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $env:TEMP 'doPDF\doPDF_installer.exe'
   url          = 'https://download.dopdf.com/download/setup/dopdf-full.exe'
   checksum     = '0fd56342e6e1e3948ed49bae45e7c1e93a45e6f66bc837c242bd5d37471b23cd'
   checksumType = 'sha256'
   GetOriginalFileName = $true
}
$LocalFile = Get-ChocolateyWebFile @DownloadArgs

# doPDF depends on the Print Spooler service so make sure it is up and running 
#    (Stolen from cutepdf package and thanks to bcurran3.)
try {
   $serviceName = 'Spooler'
   $spoolerService = Get-WmiObject -Class Win32_Service -Property StartMode,State -Filter "Name='$serviceName'"
   if ($spoolerService -eq $null) { 
      Write-Warning 'The Print Spooler service must be running for doPDF to install.'
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

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $LocalFile
   silentArgs     = '/SILENT /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /Languages="es-en"'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @InstallArgs

If ($pp.contains('NoTelemetry')) {
   Write-Host 'Attempting to disable telemetry.' -ForegroundColor Cyan
   $KeyPath = 'HKLM:\SOFTWARE\Softland\novaPDF 11\doPdf_Softland'
   Set-ItemProperty -Path $KeyPath -Name 'SendTelemetry' -Value 'False' -Force
}

