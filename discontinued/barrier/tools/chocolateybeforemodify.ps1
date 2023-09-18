$ErrorActionPreference = 'Stop'

foreach ($process in (Get-Process "$env:ChocolateyPackageName*" -ErrorAction SilentlyContinue)) {
   Stop-Process -Name $process.ProcessName -Force
}