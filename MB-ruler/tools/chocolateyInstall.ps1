$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName  = 'mbruler'
$version = '5.3'
$toolsDir     = Split-Path -parent $MyInvocation.MyCommand.Definition
$DownloadUrl  = "http://www.markus-bader.de/MB-Ruler/mbruler$($version.replace('.','')).zip"
 
$tempDir = Join-Path $env:TEMP $packageName
if (![System.IO.Directory]::Exists($tempDir)) {
   [System.IO.Directory]::CreateDirectory($tempDir)
}
 
$ZipFilePath = Join-Path $tempDir $DownloadURL.split('/')[-1]
 
# Download zip
Get-ChocolateyWebFile $packageName $ZipFilePath $DownloadURL
 
# Extract zip
Get-ChocolateyUnzip $ZipFilePath $tempDir

$InstallArgs = @{
   packageName   = $packageName
   fileType      = 'exe'
   url = (Join-Path $tempDir "MB-Ruler$($version.replace('.','')).exe")
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
