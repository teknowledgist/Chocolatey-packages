$ErrorActionPreference = 'Stop'

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$ModuleDir  = $env:psmodulepath.split(';') | Where-Object {$_ -like "$env:programfiles*"} | Select-Object -first 1

# remove the old version for an upgrade
Remove-Item -Force -Recurse "$ModuleDir\LaRGH" -ErrorAction ignore

Write-Host "LaRGH module successfully removed from this system."

