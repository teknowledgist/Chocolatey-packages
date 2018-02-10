$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$url         = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP1/DraftSight32.exe'
$url64       = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP1/DraftSight64.exe'
$checkSum    = 'c87acd1c1db75145bd7a1c4661c4e5c165fbc483048234c6781aeaf19cb8969c'
$checkSum64  = '9de917cf8fdb5da7e6dedeed9e35419eee6b8ab544e9d655d1c16f92e3893677'

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
