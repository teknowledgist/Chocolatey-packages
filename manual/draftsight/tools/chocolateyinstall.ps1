$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url         = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2019SP2/DraftSight32.exe'
$url64       = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2019SP2/DraftSight64.exe'
$checkSum    = '7a632d6da849f05b721117225223a889da9937b383f5fdb1fbaabaa80e023a47'
$checkSum64  = '08fab86549c9669c8e3610714f1a071fcef335c8b31352c0935080c84969b164'

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
