$ErrorActionPreference = 'Stop'

$DownloadArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $env:TEMP "doPDF\doPDF_installer.exe"
   url          = 'http://download.dopdf.com/download/setup/dopdf-full.exe'
   checksum     = '283ad934b473e9d1deb769f2ecb704624f0a351f315193d1c8aadd30f9fae141'
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
      Write-Warning "The Print Spooler service must be running for doPDF to install."
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

$ahkExe = 'AutoHotKey'
$toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "$ahkFile" -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   File           = $LocalFile
   silentArgs    = ''   #/SILENT /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /Languages="es-en"'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @InstallArgs

