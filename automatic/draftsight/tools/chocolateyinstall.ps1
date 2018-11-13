$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$url         = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP3/DraftSight32.exe'
$url64       = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2018SP3/DraftSight64.exe'
$checkSum    = '916ed3d4d5d740d372f53db71676c89e0081b272b1bf541fe3e9b8231e60b619'
$checkSum64  = 'e17837ebd6a7c062d2502a397308a7a34515462834b23fbc134e686d4b3de195'

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
