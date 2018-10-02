$ErrorActionPreference = 'Stop'

$DownloadArgs = @{
   packageName         = $env:ChocolateyPackageName
   url                 = 'http://media.accelrys.com/downloads/draw/2018/BIOVIADraw-2018_AE_32bit.zip'
   url64               = 'http://media.accelrys.com/downloads/draw/2018/BIOVIADraw-2018_AE_64bit.zip'
   Checksum            = 'c1fcb2ac0b00f2e5b86ffbcf3692d60a27085cc64de82015831ff78954c56870'
   Checksum64          = 'c73744eebed778608fcc13068eb9497a86f5a3e753a8ddcd628e13ebd2db7154'
   ChecksumType        = 'sha256'
   GetOriginalFileName = $true
   FileFullPath        = Join-Path $env:TEMP "$env:ChocolateyPackageName\download.zip"
}
$ZipFile = Get-ChocolateyWebFile @DownloadArgs

$UnzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = Split-Path $DownloadArgs.FileFullPath
}
Get-ChocolateyUnzip @UnzipArgs

$ShortTemp = (new-object -comobject scripting.filesystemobject).getfolder($env:TEMP).shortpath

$InstallArgs = @{
   packageName = $env:ChocolateyPackageName
   FileType = 'exe'
   File = (Get-ChildItem $UnzipArgs.Destination -Include '*.exe' -Recurse).FullName
   silentArgs = "/s /v`"/qn /norestart /l*v $($ShortTemp)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
   validExitCodes = @(0,3010)  
}
Install-ChocolateyInstallPackage @InstallArgs
