$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$unzipArgs = @{
   FileFullPath = (Get-ChildItem -Path $toolsDir -Filter "*.zip").FullName
   Destination  = Join-Path $env:TEMP $env:ChocolateyPackageName
}

Get-ChocolateyUnzip @unzipArgs

$bits = Get-OSArchitectureWidth
$InstallerFile = (Get-ChildItem -Path $unzipArgs.Destination -Filter "*win$($bits)*.msi" -Recurse).FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'msi'
   file           = $InstallerFile
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
   validExitCodes = @(0)
   softwareName   = 'Screensaver Operations*'
}

Install-ChocolateyInstallPackage @packageArgs
