$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$version     = '2017SP01'
$url         = "http://dl-ak.solidworks.com/nonsecure/draftsight/$version/DraftSight32.exe"
$url64       = "http://dl-ak.solidworks.com/nonsecure/draftsight/$version/DraftSight64.exe"
$checkSum    = 'D764DE6A8A6BEFEBDF2D35FBA4A23A9D74E1629BE9733AE29CAADCE061AEDBB8'
$checkSum64  = '0C9EF0396F0F38E806CD29976AFDBF8EAC0ADD7E8180C7F4EF004A74A4EC3B8D'

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
