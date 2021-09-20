$ErrorActionPreference = 'Stop'

$OSversion = [version](Get-WmiObject -Class Win32_OperatingSystem).version 
if ($OSversion -eq $null -or $OSversion -lt [Version]'6.2') {
  Write-Host "This version of Markdown-Edit is designed for use with fonts that do not come with this version of Windows." -ForegroundColor Cyan
}

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$Installer = Get-ChildItem $toolsDir -filter '*.msi' | Sort-Object LastWriteTime | Select-Object -Last 1

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'msi'
   File64         = $Installer.fullname
   silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs 

remove-item $Installer.fullname -Force
