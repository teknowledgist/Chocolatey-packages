$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FileLocations = Get-ChildItem -Path $toolsDir -Filter '*.exe' | select -ExpandProperty FullName

$packageArgs = @{
  packageName  = $env:ChocolateyPackageName
  fileType     = 'EXE' 
  File         = $FileLocations | Where-Object {$_ -notmatch '64bit'}
  File64       = $FileLocations | Where-Object {$_ -match '64bit'}
  softwareName = $env:ChocolateyPackageName.split('.')[0]
  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  validExitCodes= @(0)
}

# The installer doesn't properly kill ditto
Get-Process | Where-Object { $_.name -eq 'ditto' } | Stop-Process

Install-ChocolateyInstallPackage @packageArgs

foreach ($exe in $FileLocations) {
   New-Item "$exe.ignore" -Type file -Force | Out-Null
}
