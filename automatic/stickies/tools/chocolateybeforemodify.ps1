$ErrorActionPreference = 'Stop'

if (Get-Process $env:ChocolateyPackageName -ErrorAction SilentlyContinue) {
   Stop-Process -Name $env:ChocolateyPackageName -Force
}
