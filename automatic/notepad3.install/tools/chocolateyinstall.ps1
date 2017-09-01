$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName= $env:ChocolateyPackageName
$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE' 
  file          = $fileLocation
  softwareName  = "$env:ChocolateyPackageName*"
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}

Install-ChocolateyInstallPackage @packageArgs

