$ErrorActionPreference = 'Stop'

$packageName = 'DraftSight'
$url = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP0/DraftSight32.exe'
$url64 = 'https://dl-ak.solidworks.com/nonsecure/draftsight/2020SP0/DraftSight64.exe'
$checkSum = '7126d6e181b9efac411a094af86b5af5087e837af7a68115099095064c9f020f'
$checkSum64 = 'd64fb5c760c5c9b73db7e06f37851f57d4e7284957126c144c55ad174db32244'

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
