$ErrorActionPreference = 'Stop'

$pp = Get-PackageParameters

If (!$pp.count) {
   $SilentArgs = '/S'  # /S uses all default options -- some of which require re-install to set.
} else {
   $SilentArgs = ''
   $ahkArgs = Get-OSArchitectureWidth + ' '
}
if (!$pp.contains("Icon")) {
   $ahkArgs += 'D'
} elseif ($pp["Icon"]) {
   Write-Host 'You requested an xplorer² desktop icon.'
   $ahkArgs += 'D'
} else {
   Write-Host 'You requested NO xplorer² desktop icon.'
}
if (!$pp.contains("Skin")) {
   $ahkArgs += 'M'
} elseif ($pp["Skin"]) {
   Write-Host 'You requested a modern skin in xplorer².'
   $ahkArgs += 'M'
} else {
   Write-Host 'You requested NO modern skin in xplorer².'
}
if (!$pp.contains("Replace")) {
   $ahkArgs += 'R'
} elseif ($pp["Replace"]) {
   Write-Host 'You requested to replace Explorer with xplorer².'
   $ahkArgs += 'R'
} else {
   Write-Host 'You requested to NOT replace Explorer with xplorer².'
}
if (!$pp.contains("All")) {
   $ahkArgs += 'A'
} elseif ($pp["All"]) {
   Write-Host 'You requested to replace Explorer with xplorer² for ALL users.'
   $ahkArgs += 'A'
} else {
   Write-Host 'You requested to NOT replace Explorer with xplorer² for all other users.'
}
if (!$pp.contains("Menu")) {
   $ahkArgs += 'C'
} elseif ($pp["Menu"]) {
   Write-Host 'You requested to include xplorer² in folder context menus.'
   $ahkArgs += 'C'
} else {
   Write-Host 'You requested NOT include xplorer² in folder context menus.'
}
if (!$pp.contains("Language")) {
   Write-Host ('You requested to set the xplorer² language to ' + $pp["Language"] + '.')
   $ahkArgs += ' ' + $pp["Language"]
}

# silent install requires AutoHotKey
$ahkExe = 'AutoHotKey'
$toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkArgs" -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"


$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   url            = 'http://zabkat.com/3502.exe'
   url64          = 'http://zabkat.com/3502_64.exe'
   softwareName   = 'xplorer² Pro*'
   checksum       = '5612B236AF9A90D1528FAFE7D62C66EA56B8FC97AA9DFADB5880B2472953CD14'
   checksum64     = 'B689D9F6DDAE80C736677574D23992754DC7F54D87C4D4CC8009CA3DBC462FBE'
   checksumType   = 'sha256'
   silentArgs     = $SilentArgs
   validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 

