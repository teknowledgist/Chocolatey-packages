$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

$ZipFile = (Get-ChildItem $toolsDir -Filter '*.zip').FullName

If ($ZipFile) {
   $UnzipDir = Join-Path $env:TEMP "$env:ChocolateyPackageName_$env:ChocolateyPackageVersion"
   # Extract zip
   Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $UnzipDir
} else {
   $UnzipDir = $toolsDir
}

$Installer = (Get-ChildItem $UnzipDir -Filter '*.exe').FullName

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   fileType     = 'EXE' 
   File         = $Installer
   softwareName = "$env:ChocolateyPackageName*"
   silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
}

Install-ChocolateyInstallPackage @packageArgs

if ($UnzipDir -eq $toolsDir) {
   $null = New-Item "$Installer.ignore" -Type file -Force
}
