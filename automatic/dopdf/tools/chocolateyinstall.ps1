$ErrorActionPreference = 'Stop'

$DownloadArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $env:TEMP "doPDF\doPDF_installer.exe"
   url          = 'http://download.dopdf.com/download/setup/dopdf-full.exe'
   checksum     = '1da9fe7ff9623c5646aa1a2cf9a9759d7453aceba755241d2c6e4c561f451541'
   checksumType = 'sha256'
   GetOriginalFileName = $true
}
$LocalFile = Get-ChocolateyWebFile @DownloadArgs


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

