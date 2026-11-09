$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$PSEChecksum = 'CBC86048C9C5A9DE697D29EA3650BECABBFAE5A6FC276785EECA3AAD938F3292'
$PSEChecksum64 = '8F63A763F6D71FA88BF0CCEEFE647AB5724836DB9B9402F8ECDB0D21741A5BFD'

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
