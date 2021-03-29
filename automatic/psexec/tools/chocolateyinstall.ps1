$ErrorActionPreference = 'Stop'

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$Checksum = '0d6ba2f1f2bf290b71bde12f095a6c9697aac7794bc2523f86b383b82f73a430'

# Remove old versions
$null = Get-ChildItem -Path $env:ChocolateyPackageFolder -Filter *.exe | Remove-Item -Force

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url            = $Url
   Checksum       = $checkSum
   ChecksumType   = 'sha256'
   GetOriginalFileName = $true
}
$PsToolsZip = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $PsToolsZip
   Destination  = $WorkSpace
}
Get-ChocolateyUnzip @UnzipArgs

Get-ChildItem $WorkSpace -Filter 'psexec*.exe' | Copy-Item -Destination $env:ChocolateyPackageFolder -Force

