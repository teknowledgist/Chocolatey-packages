$ErrorActionPreference = 'Stop'

$Url      = 'https://download.sysinternals.com/files/PSTools.zip'
$PSEChecksum = '57492d33b7c0755bb411b22d2dfdfdf088cbbfcd010e30dd8d425d5fe66adff4'
$PSEChecksum64 = 'a9affdcdb398d437e2e1cd9bc1ccf2d101d79fc6d87e95e960e50847a141faa4'

# Remove old versions
$null = Get-ChildItem -Path $env:ChocolateyPackageFolder -Filter *.exe | Remove-Item -Force

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

# PSExec is a subcomponent of PSTools in which any other subcomponent
#    could change without any change to PSExec.  This makes tracking
#    the checksum very difficult, so that aspect is skipped here.
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

Get-ChildItem $WorkSpace -Exclude 'psexec*.exe' -Recurse | ForEach-Object {Remove-Item $_.Fullname -Force}
