$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$url         = 'http://zabkat.com/dl/xplorer2_lite_setup.exe'
$Checksum    = 'e4982628f10d578b8f4e2d6ccf54f6f536f7e7e37b459ea4af8fc2bc04dddbe8'

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
