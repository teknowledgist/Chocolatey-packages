$ErrorActionPreference = 'Stop'

# Quit previous versions
$Clock = Get-Process | Where-Object {$_.path -like "$env:ChocolateyPackageFolder*"}
if ($Clock) {
   & "$($Clock.path)" /exit
}