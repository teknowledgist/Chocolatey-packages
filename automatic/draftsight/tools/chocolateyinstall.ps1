$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$url         = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP0/DraftSight32.exe'
$url64       = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP0/DraftSight64.exe'
$checkSum    = '5877d9b50df0170940f28d186c380e797e1d4b3a5c989464eedf98b421efc046'
$checkSum64  = '3ee1c2bcb6cc8fa74ae23c9528fdb568cd5f690a6cb554bbbda1501de682fd66'

# if an older version of DraftSight has been run, the API service will prevent upgrading it.
if (Get-Service -DisplayName "Draftsight API Service*" | Where {$_.status -eq 'running'}) {
   Stop-Service -DisplayName "Draftsight API Service*" -Force -PassThru
}

$WorkSpace = Join-Path $env:TEMP "$packageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $packageName
   FileFullPath = Join-Path $WorkSpace "$packageName.exe"
   Url          = $url
   Url64bit     = $url64
   Checksum     = $checkSum
   Checksum64   = $checkSum64
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $packageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   PackageName    = $packageName
   File           = Join-Path $WorkSpace "$packageName.msi"
   fileType       = 'msi'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
