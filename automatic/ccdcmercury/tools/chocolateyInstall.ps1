$PackageName = 'ccdcmercury'
$Version     = '3.10.1'
$url         = 'https://downloads.ccdc.cam.ac.uk/Mercury/3.10.1/mercurystandalone-3.10.1-windows-installer.exe'
$Checksum    = '0065658223cd36d8b39e433c5edafd3f5989aa3cfa5f6a1ed71d7b858ff211ad'

$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $InstallDir = Join-Path ${env:ProgramFiles(x86)} "\CCDC\Mercury $Version"
} else {
   $InstallDir = Join-Path $env:ProgramFiles "\CCDC\Mercury $Version"
}

$InstallArgs = @{
   packageName    = $PackageName
   installerType  = 'exe'
   url            = $url
   checkSum       = $Checksum
   ChecksumType   = 'sha256'
   silentArgs     = '--mode unattended --prefix "' + $InstallDir + '"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

