$ErrorActionPreference = 'Stop'

$ModuleName = $env:ChocolateyPackageName.replace('.powershell','')
# Disable the module so it can be removed
Remove-Module -Name $ModuleName -Force -ErrorAction SilentlyContinue