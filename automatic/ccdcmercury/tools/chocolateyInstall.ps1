$PackageName = 'ccdcmercury'
$Version     = 3.8
$url         = 'https://downloads.ccdc.cam.ac.uk/Mercury/3.8/mercurystandalone-3.8-windows-installer.exe'
$Checksum    = '2a683404255bee05747e797816ea51bbae368c58f8201037fd6c4b47b416df20'

$InstallDir = "C:\Program Files (x86)\CCDC\Mercury $Version"

$InstallArgs = @{
   packageName = $PackageName
   installerType = 'exe'
   url = $url
   checkSum = $Checksum
   silentArgs = '--mode unattended --prefix "' + $InstallDir + '"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

