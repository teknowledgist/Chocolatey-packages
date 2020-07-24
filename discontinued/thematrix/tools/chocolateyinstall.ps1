$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile   = (Get-ChildItem $toolsDir -filter "*.zip").FullName
$Destination = Join-Path $env:Temp "$env:ChocolateyPackageName"

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $Destination

$SCRfilePath = Get-ChildItem $Destination -filter "*.scr"
copy-item $SCRfilePath.fullname $env:Windir -force

