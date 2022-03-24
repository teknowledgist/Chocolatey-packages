$ErrorActionPreference = 'Stop'

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'

# Remove old versions
$null = Get-ChildItem -Path $env:ChocolateyPackageFolder -Filter *.exe | Remove-Item -Force

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

# PSExec is a subcomponent of PSTools in which any other subcomponent
#    could change without any change to PSExec.  This makes tracking
#    the checksum very difficult, so that aspect is skipped here.
$WebFileArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url            = $Url
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

