$PackageName = 'ccdcmercury'
$Version     = '3.9'
$url         = 'https://downloads.ccdc.cam.ac.uk/Mercury/3.9/mercurystandalone-3.9-windows-installer.exe'
$Checksum    = '2a683404255bee05747e797816ea51bbae368c58f8201037fd6c4b47b416df20'

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
   silentArgs     = '--mode unattended --prefix "' + $InstallDir + '"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

