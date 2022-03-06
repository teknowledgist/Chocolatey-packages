$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2022SP1-1/DraftSight32.exe'
$url64 = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2022SP1-1/DraftSight64.exe'
$checkSum = 'b61dda409c81f8788a0f3be776d1ea7cf7b1fe3a985068d61e814306fbdd31d4'
$checkSum64 = 'b61dda409c81f8788a0f3be776d1ea7cf7b1fe3a985068d61e814306fbdd31d4'

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

# Just guessing here, but:
#
# LICENSETYPE=0 req_trial
# LICENSETYPE=1 req_activation
# LICENSETYPE=2 req_license_dsls
# LICENSETYPE=3 req_license_snl

$InstallArgs = @{
    PackageName    = $packageName
    File           = Join-Path $WorkSpace "$packageName.msi"
    fileType       = 'msi'
    silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1 LICENSETYPE=0"
    validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
