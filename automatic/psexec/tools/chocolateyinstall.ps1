$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$PSEChecksum = '078163D5C16F64CAA5A14784323FD51451B8C831C73396B967B4E35E6879937B'
$PSEChecksum64 = 'EDFAE1A69522F87B12C6DAC3225D930E4848832E3C551EE1E7D31736BF4525EF'

# Remove old versions
$null = Get-ChildItem -Path $FolderOfPackage -Filter *.exe | Remove-Item -Force

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
   Copy-Item $EXEfile.fullname -Destination $FolderOfPackage -Force
}

# None of the other binaries are verified, so delete them all.
Get-ChildItem $WorkSpace -Exclude 'psexec*.exe' -Recurse | ForEach-Object {Remove-Item $_.Fullname -Force}
