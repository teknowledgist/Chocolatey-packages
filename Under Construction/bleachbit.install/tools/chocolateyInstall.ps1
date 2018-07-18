$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = "BleachBit"
  File          = $fileLocation
  fileType      = "exe"
  silentArgs    = "/S"
  validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @packageArgs

New-Item "$fileLocation.ignore" -Type file -Force | Out-Null

if (test-path (Join-Path $env:USERPROFILE "BleachBit.lnk")) {

}
(Get-ChildItem -Path $toolsDir -Filter "BleachBit.lnk").FullName