$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Quit previous versions
$RBTray = Get-Process | Where-Object {$_.path -like "$FolderOfPackage*"}
if ($RBTray) {
   & "$($RBTray.path)" --exit
}
