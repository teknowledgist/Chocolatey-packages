$ErrorActionPreference = 'Stop'

# Quit previous versions
$RBTray = Get-Process | Where-Object {$_.path -like "$env:ChocolateyPackageFolder*"}
if ($RBTray) {
   & "$($RBTray.path)" --exit
}
