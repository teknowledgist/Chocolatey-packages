$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP1-1/DraftSight32.exe'
$url64 = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP1-2/DraftSight64.exe'
$checkSum = 'e3c27bc9558f9140f5ed67ca1ee34ccadd5152483be62c57ca61072211f5dbc6'
$checkSum64 = 'bbe86ec7446f524ab396b8a598a397e47851156cb8352da5c182e61a5bf91888'

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
