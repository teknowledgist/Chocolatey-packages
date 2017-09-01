$packageName = 'bioviadraw-ae'

$DownloadArgs = @{
   packageName         = $packageName
   url                 = 'http://media.accelrys.com/downloads/draw/2017/BIOVIADraw-2017_R2_AE_32bit.zip'
   url64               = 'http://media.accelrys.com/downloads/draw/2017/BIOVIADraw-2017_R2_AE_64bit.zip'
   Checksum            = 'E31AAACF64114D7B953BC09424667CF234DA10DA7A78260A38C46E1D7F37E94B'
   Checksum64          = 'BC5DBADE1EA2EA47B17489D91C7AC1F235622E5A8D6072F94DC90674932106CC'
   ChecksumType        = 'sha256'
   GetOriginalFileName = $true
   FileFullPath        = Join-Path $env:TEMP "$packageName\download.zip"
}
$ZipFile = Get-ChocolateyWebFile @DownloadArgs

$UnzipArgs = @{
   packageName  = $packageName
   FileFullPath = $ZipFile
   Destination  = Split-Path $DownloadArgs.FileFullPath
}
Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   packageName = $packageName
   FileType = 'exe'
   File = (Get-ChildItem $UnzipArgs.Destination -Include '*.exe' -Recurse).FullName
   silentArgs = "/s /v`"/qn /norestart /l*v $($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0,1603,3010)  
   # 1603 is normally a problematic exit code, but for this version it is a known bug
   # as can be seen here:
   #   https://community.3dsbiovia.com/Communities_Topics?tid=09a500000004QeHAAU&id=90638000000LCfgAAG
   # A fix is in the works for the next version.
   # Chocolatey will warn still warn about the irregular exit.  
}
Install-ChocolateyInstallPackage @InstallArgs
