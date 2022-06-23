$ErrorActionPreference = 'Stop'  # stop on all errors

if ([version]((Get-WmiObject Win32_OperatingSystem).version) -lt [version]'10.0') {
   Throw "This version of MB-Ruler requires at least Windows 10.  Please install an earlier version of this package."
}

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$ZipFile = Get-ChildItem -Path $toolsDir -Filter '*.zip' | 
               Sort-Object LastWriteTime | Select-Object -ExpandProperty FullName -Last 1

$WorkingFolder = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion"

# Extract zip
Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $WorkingFolder
Remove-Item $ZipFile -Force 

$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   fileType      = 'exe'
   File          = (Get-ChildItem -Path "$WorkingFolder\*.exe").FullName
   silentArgs    = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyInstallPackage @InstallArgs
