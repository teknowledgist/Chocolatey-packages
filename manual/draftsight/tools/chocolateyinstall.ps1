$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2019SP3/DraftSight32.exe'
$url64 = 'http://dl-ak.solidworks.com/nonsecure/draftsight/2019SP3/DraftSight64.exe'
$checkSum = '39f1ec30b921fbbea8f6060612de3a073f8144b22701e3e2e4744bda3a5eb138'
$checkSum64 = '31218d74987b200ffceab41b959e81a242345b2bd61222ca85a51b9c805d45c9'

# if an older version of DraftSight has been run, the API service will prevent upgrading it.
if (Get-Service -DisplayName "Draftsight API Service*" | Where { $_.status -eq 'running' }) {
   Stop-Service -DisplayName "Draftsight API Service*" -Force -PassThru
}

$WorkSpace = Join-Path $env:TEMP "$packageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName         = $packageName
   FileFullPath        = Join-Path $WorkSpace "$packageName.exe"
   Url                 = $url
   Url64bit            = $url64
   Checksum            = $checkSum
   Checksum64          = $checkSum64
   ChecksumType        = 'sha256'
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
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1 LICENSETYPE=0"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
