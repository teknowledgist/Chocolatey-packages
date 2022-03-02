$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile = Get-ChildItem -Path $toolsDir -Filter '*.zip' | 
               Sort-Object LastWriteTime | Select-Object -Last 1
$Destination = Join-Path $env:Temp "$env:ChocolateyPackageName\$env:ChocolateyPackageVersion"

Get-ChocolateyUnzip -FileFullPath $ZipFile.fullname -Destination $Destination

$SCRfilePath = Get-ChildItem $Destination -filter "*.scr"
copy-item $SCRfilePath.fullname $env:Windir -force

Remove-Item $ZipFile.FullName -ea 0 -force
Remove-Item $Destination -recurse -ea 0 -force
