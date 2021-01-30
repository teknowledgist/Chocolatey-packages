$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP4-1/DraftSight32.exe'
$url64 = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP4-1/DraftSight64.exe'
$checkSum = 'e8bea881bbdc7634745e046f55f37ee1d1d11c481b8069f4e28b299b8e99b2ff'
$checkSum64 = '68a09d9f8e8ef742e65afa7c0a82bccc4167e58261f9c0b19f80ee67bc60d251'

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
