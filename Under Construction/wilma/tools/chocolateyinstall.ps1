$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
   url           = 'http://www.stefandidak.com/wilma/winlayoutmanager.zip'
   checksum      = 'C5EDEA1BC867A48CB0AD15D7F2A590143D2D8F8659715A33EFA0B02FE6A4BCEA'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

