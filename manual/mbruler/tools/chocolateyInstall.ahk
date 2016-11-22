$ErrorActionPreference = 'Stop'  # stop on all errors
$packageName  = 'mbruler'
$version = '5.3'

$URL = "http://www.markus-bader.de/MB-Ruler/$packageName$($version.replace('.','')).zip"
$WorkingFolder = Join-Path -Path $env:TEMP -ChildPath $packageName


$PackageArgs = @{
  PackageName = $packageName
  FileFullPath = Join-Path -Path $WorkingFolder -ChildPath "$packageName$($version.replace('.','')).zip"
  Url = $URL
  checkSum = 'F7A245C32E0F9A4336E36B9B500FE750FB71B16574BF957287CF56C86EC210B5'
}
  
# Download zip
Get-ChocolateyWebFile @PackageArgs
 
# Extract zip
Get-ChocolateyUnzip $PackageArgs.FileFullPath $WorkingFolder

$InstallArgs = @{
   packageName   = $packageName
   fileType      = 'exe'
   url = Join-Path -Path $WorkingFolder -ChildPath (Get-ChildItem -Path "$WorkingFolder\*.exe").Name
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @InstallArgs
