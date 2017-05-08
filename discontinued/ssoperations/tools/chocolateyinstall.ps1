$ErrorActionPreference = 'Stop'

$packageName= 'ssoperations'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$unzipArgs = @{
   FileFullPath = Join-Path $toolsDir 'ssoperations_1.4_win32_64.zip'
   Destination  = Join-Path $env:TEMP "$packageName"
}

Get-ChocolateyUnzip @unzipArgs

$bits = Get-OSArchitectureWidth

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  file          = Join-Path $env:TEMP "$packageName\ssoperations_1.4_win$($bits)_setup.msi"
  silentArgs    = "/qn /norestart"
  validExitCodes= @(0)
  softwareName  = 'Screensaver Operations'
}

Install-ChocolateyInstallPackage @packageArgs
