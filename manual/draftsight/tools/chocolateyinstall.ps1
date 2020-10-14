$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP3-1/DraftSight32.exe'
$url64 = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP3-1/DraftSight64.exe'
$checkSum = 'a2ba6c33aace5a4e1a5c39278615e7251d8c6291722e89947ce95fed8fece531'
$checkSum64 = '5364dec1f3d980086e94f041c2ebb2790c9f6990fd223e39e578ec3f2bee26cb'

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
