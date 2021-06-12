$ErrorActionPreference = 'Stop'

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$Checksum = 'fc9a9d961eb4e9f069d53d29c7c3ef7d00b11754807b528c43a44e9e57e1cfae'

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

