$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Quit previous versions
$Clock = Get-Process | Where-Object {$_.path -like "$PackageFolder*"}
if ($Clock) {
   & "$($Clock.path)" /exit
}