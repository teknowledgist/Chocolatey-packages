$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Quit previous versions
$RBTray = Get-Process | Where-Object {$_.path -like "$PackageFolder*"}
if ($RBTray) {
   & "$($RBTray.path)" --exit
}
