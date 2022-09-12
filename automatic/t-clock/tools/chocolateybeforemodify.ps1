$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Quit previous versions
$Clock = Get-Process | Where-Object {$_.path -like "$FolderOfPackage*"}
if ($Clock) {
   & "$($Clock.path)" /exit
}