$PackageName = 'ccdcmercury'
$Version     = '3.10'
$url         = 'https://downloads.ccdc.cam.ac.uk/Mercury/3.10/mercurystandalone-3.10-windows-installer.exe'
$Checksum    = '51a25f4c946838caced12c8b2aa50f21223f20d59d63cb0a9be5e5536ac3b290'

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

