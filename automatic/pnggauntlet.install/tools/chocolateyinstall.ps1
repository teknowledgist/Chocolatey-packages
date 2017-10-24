$ErrorActionPreference = 'Stop'

$packageName='PNGGauntlet'

$DownloadFile = "$packageName-3.1.2.exe"
$DestinationDir = Join-Path $env:TEMP $packageName

$PackageArgs = @{
  PackageName = $packageName
  FileFullPath = Join-Path $DestinationDir $DownloadFile
  Url = 'https://pnggauntlet.com/PNGGauntlet-3.1.2.exe'
  checkSum = '1155CB66555764D497962D7857EB61D3EA13D5E6CA4C847FB0A4BBC46B802E83'
  checkSumType = 'sha256'
}

# Download zip
Get-ChocolateyWebFile @PackageArgs

# Extract zip
Get-ChocolateyUnzip (Join-Path $DestinationDir $DownloadFile) $DestinationDir

$InstallArgs = @{
   packageName   = $packageName
   fileType      = 'msi'
   silentArgs = "/qn"
   validExitCodes= @(0)
   File = (Join-Path $DestinationDir "Installer\$($packageName)Setup.msi")
}

Install-ChocolateyInstallPackage @InstallArgs

