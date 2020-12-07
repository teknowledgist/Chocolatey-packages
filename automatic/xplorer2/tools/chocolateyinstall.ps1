$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$url         = 'http://zabkat.com/dl/xplorer2_lite_setup.exe'
$Checksum    = '250e0439bfb0440e0988d87bc566d765ac49a48327f929c7f7439d2070c2ff7c'

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
