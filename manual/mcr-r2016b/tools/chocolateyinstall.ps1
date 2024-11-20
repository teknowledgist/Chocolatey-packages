$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName = 'mcr-r2016b'
$Version     = '9.1'

$WorkSpace = Join-Path $env:TEMP "$packageName.$Version"

$WebFileArgs = @{
   packageName  = $packageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url64bit     = 'https://www.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/win64/MCR_R2016b_win64_installer.exe'
   Checksum64   = 'A290F18CD3A21EB09181ED3B0D6A6C9857893FB2321D4F808EEF1F5659ABE20D'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$msgtext = 'MATLAB Runtime is large, so it may take awhile to download and install.  Please be patient.'
Write-Host $msgtext -ForegroundColor Cyan

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName = $packageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$Installer = (Get-ChildItem $WorkSpace -Filter 'setup.exe').fullname

$InstallArgs = @{
   PackageName = $packageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}

Install-ChocolateyInstallPackage @InstallArgs

$UpdateArgs = @{
   PackageName    = "$Packagename-Updater"
   URL64bit       = 'https://ssd.mathworks.com/supportfiles/downloads/R2016b/deployment_files/R2016b/installers/win64/MCR_R2016b_Update_6.exe'
   FileType       = 'exe'
   Checksum64     = '2bceb861f139ad47a0c23ac30d5da17040cab7f553b26d7546175895a466ef08'
   ChecksumType64 = 'SHA256'
   SilentArgs     = '/S'
}
Install-ChocolateyPackage @UpdateArgs