$InstallArgs = @{
   packageName = 'fragstats'
   installerType = 'exe'
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

$exeName = 'frg_setup_4.2.exe'
$DownloadURL = 'http://www.umass.edu/landeco/research/fragstats/downloads/fragstats4.2.zip'

$tempDir = Join-Path $env:TEMP $installArgs.packageName
if (![System.IO.Directory]::Exists($tempDir)) {
   [System.IO.Directory]::CreateDirectory($tempDir)
}
 
$ZipPath = Join-Path $tempDir $DownloadURL.split('/')[-1]
 
# Download zip
Get-ChocolateyWebFile $InstallArgs.packageName $ZipPath $DownloadURL
 
# Extract zip
Get-ChocolateyUnzip $ZipPath $tempDir
 
$InstallArgs += @{ url = (Join-Path $tempDir $exeName) }
 
# Execute installer
Install-ChocolateyPackage @InstallArgs

