$ErrorActionPreference = 'Stop'

$packageName = 'ScientificWord'
$url         = 'https://s3-us-west-1.amazonaws.com/download.mackichan.com/sw-6.0.28-windows-installer.exe'
$Checksum    = '901dd8f1bd7d3fe304c070a77787d1f5626a347abbb898c361f5a2b87264e72d'

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'EXE'
  url           = $url
  softwareName  = 'Scientific Word*'
  checksum      = $Checksum
  checksumType  = 'sha256'
  silentArgs    = '--mode unattended --unattendedmodeui none'
  validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs

$UserArguments = Get-PackageParameters

if (!$UserArguments) {
   Write-Debug 'No Package Parameters Passed in.  Collecting 30-day Serial Number.'
   $WebClient = New-Object System.Net.Webclient
   $DownloadURL  = 'https://www.mackichan.com/products/dnloadreq.html'
   $DownloadPage = $webclient.DownloadString($DownloadURL)
   $SN = $DownloadPage -replace '(?smi).*title=.Scientific Word.*?(\d\d\d-E[0-9-]+).*','$1'
   $Desktop = [System.Environment]::GetFolderPath('Desktop')
   $SN | Out-File (Join-Path $Desktop 'Scientific Word Trial Serial Number.txt') -Force
}

if ($UserArguments['LicenseFile']) {
   Write-Host "You requested copying a license file from '$($UserArguments.LicenseFile)'."
   if (test-path $UserArguments[licenseFile]) {
      [array]$key = Get-UninstallRegistryKey -SoftwareName 'Scientific Word'
      $Destination = Join-Path (Split-Path $key.UninstallString) 'SW'
      Copy-Item $UserArguments.LicenseFile $Destination -Force
   } else {
      Write-Warning "LicenseFile '$($UserArguments[LicenseFile])' not found!"
   }
}

if ($UserArguments['SystemVariable']) {
   Write-Host "You requested the 'mackichn_LICENSE' environment variable be set to '$($UserArguments.SystemVariable)'."
   Write-Warning 'No check on the accuracy or existance of the information will be made.'

   $EnVarArgs = @{
      VariableName  = 'mackichn_LICENSE'
      VariableValue = $UserArguments.SystemVariable
      VariableType  = 'Machine'
   }
   Install-ChocolateyEnvironmentVariable @EnVarArgs
}
