$ErrorActionPreference = 'Stop'

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$PSEChecksum = '08C6E20B1785D4EC4E3F9956931D992377963580B4B2C6579FD9930E08882B1C'
$PSEChecksum64 = '5910B49C041B80F6E8D2E8E10752A9062FEBE4A2EDD15F07C6B1961B3C79C129'

# Remove old versions
$null = Get-ChildItem -Path $env:ChocolateyPackageFolder -Filter *.exe | Remove-Item -Force

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

# PSExec is a subcomponent of PSTools in which any other subcomponent
#    could change without any change to PSExec.  This makes tracking
#    the version very difficult, so the download checksum is skipped here.
$WebFileArgs = @{
   packageName         = $env:ChocolateyPackageName
   FileFullPath        = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url                 = $Url
   GetOriginalFileName = $true
}
$PsToolsZip = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $PsToolsZip
   Destination  = $WorkSpace
}
Get-ChocolateyUnzip @UnzipArgs

$PSEfile = Get-ChildItem $WorkSpace -Filter 'psexec*.exe' 
Foreach ($EXEfile in $PSEfile) {
   # Instead, the checksums of the actual PSExec binaries are compared.
   $ChecksumArgs = @{
      File         = $EXEfile.Fullname
      ChecksumType = 'SHA256'
   }
   if ($EXEfile.name -match '64') {
      $ChecksumArgs.add('Checksum',$PSEChecksum64)
   } else {
      $ChecksumArgs.add('Checksum',$PSEChecksum)
   }
   Get-ChecksumValid @ChecksumArgs
   Copy-Item $EXEfile.fullname -Destination $env:ChocolateyPackageFolder -Force
}

# None of the other binaries are verified, so delete them all.
Get-ChildItem $WorkSpace -Exclude 'psexec*.exe' -Recurse | ForEach-Object {Remove-Item $_.Fullname -Force}
