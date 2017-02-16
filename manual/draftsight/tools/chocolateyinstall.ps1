$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$version     = '2017SP0'
$url         = "http://dl-ak.solidworks.com/nonsecure/draftsight/$version/DraftSight32.exe"
$url64       = "http://dl-ak.solidworks.com/nonsecure/draftsight/$version/DraftSight64.exe"
$checkSum    = '531DA593E923413FC4BED1F5C95517C0DB9131CBC125FD4DECA23CFE1FA74103'
$checkSum64  = '94DBD59E63E6440747357432793CEEC8685B1D66EB816947140EB090E213EDAF'

$WorkSpace = Join-Path $env:TEMP "$packageName.$Version"

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

<# From the DraftSight download page:
   "It has come to the attention of the DraftSight team that, due to an expired 
   certificate, Windows* 32 & 64-bit versions of DraftSight released from 2012 
   to 2017 will not launch and/or will stop running as of March 1, 2017. However,
   we are making available a critical hotfix to resolve this issue before that date.

   To avoid usage interruption, please make sure to immediately download and 
   install this critical hotfix.
#>
$HotfixUrl      = 'http://dl-ak.solidworks.com/nonsecure/draftsight/HOTFIX-2017SP0-V1R3/DraftSight_HotFix_2017.exe'
$HotfixCheckSum = '33DD9766AB6871B47C5E277F207F9586B8BD0DD985C9CD9CFA9AA6EAE048A568'

$WebFileArgs = @{
   packageName  = "$packageName.Hotfix"
   FileFullPath = Join-Path $WorkSpace "$packageName.HotFix.exe"
   Url          = $HotfixUrl
   Checksum     = $HotfixCheckSum
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName = "$packageName.Hotfix"
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$BitLevel = Get-ProcessorBits
if ($BitLevel -eq '32') { $BitLevel = '86' }

$PatchFile = Join-Path $WorkSpace "Files\x$BitLevel$version\DDKERNEL.dll" 
Copy-Item $PatchFile "$env:ProgramFiles\Dassault Systemes\DraftSight\bin" -Force
