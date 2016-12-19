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

# Determine default browser
$HTTPDefault = (Get-ItemProperty 'registry::HKEY_CLASSES_ROOT\http\shell\open\command').'(default)' -replace '^.*\\(.*?\.exe)".*','$1'

$RedirectKey = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$HTTPDefault"
$RedirectCommand = '"c:\windows\system32\cmd.exe" /c echo > "' + (Join-Path $WorkingFolder 'CapturedCall.txt') + '"'
$exists = Test-Path $RedirectKey
if (-not $exists) {
   New-Item $RedirectKey -Force | Write-Debug
} 
   New-ItemProperty -Path $RedirectKey -Name "Debugger" -Value $RedirectCommand -Force | Write-Debug

Install-ChocolateyPackage @InstallArgs

if (-not $exists) {
   Remove-Item $RedirectKey -Recurse
} else {
   Remove-ItemProperty -Path $RedirectKey -Name 'Debugger' -Force
}
