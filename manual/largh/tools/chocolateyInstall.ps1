$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$ModuleDir  = $env:psmodulepath.split(';') | Where-Object {$_ -like "$env:programfiles*"} | Select-Object -first 1

# remove the old version for an upgrade
Remove-Item -Force -Recurse "$ModuleDir\LaRGH" -ErrorAction ignore

$null = New-Item -ItemType Directory "$ModuleDir\LaRGH" -ErrorAction Ignore

Copy-Item -Recurse -Force "$toolsPath\LaRGH"  $ModuleDir

$res = Get-Module LaRGH -ListAvailable | Where-Object { (Split-Path $_.ModuleBase) -eq $ModuleDir }
if (!$res) { throw 'Module installation failed' }

Write-Host "`n$($res.Name) version $($res.Version) installed successfully at '$ModuleDir\LaRGH'"

