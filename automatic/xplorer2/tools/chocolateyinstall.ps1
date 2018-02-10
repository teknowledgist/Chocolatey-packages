$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$url         = 'http://zabkat.com/xplorer2_lite_setup.exe'
$Checksum    = 'ac5da518eb766594bb2ae3153dcaddb2f82732b12e806baff01cb25b5e508765'

# silent install requires AutoHotKey
$ahkExe = 'AutoHotKey'
$toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$ahkFile = Join-Path $toolsDir 'chocolateyInstall.ahk'
$ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "$ahkFile" -PassThru
$ahkId = $ahkProc.Id
Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
Write-Debug "Process ID:`t$ahkId"

$packageArgs = @{
  packageName    = $packageName
  unzipLocation  = $toolsDir
  fileType       = 'EXE'
  url            = $url
  softwareName   = 'xplorer² lite*'
  checksum       = $Checksum
  checksumType   = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}
Install-ChocolateyPackage @packageArgs 
