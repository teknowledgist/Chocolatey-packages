$ErrorActionPreference = 'Stop'  # stop on all errors

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$osVersion = [version](Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty Version)

if ($osVersion.Major -lt 10) {
   $fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip' | ? {$_.name -notmatch '_10'}).FullName
} else {
   $fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*_10.zip').FullName
}

$WorkingFolder = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion"

# Extract zip
Get-ChocolateyUnzip -FileFullPath $fileLocation -Destination $WorkingFolder

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'exe'
   File          = (Get-ChildItem -Path "$WorkingFolder\*.exe").FullName
   silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
