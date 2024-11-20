$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'mcr-r2016a'
$Version     = '9.0.1'

$WorkSpace = Join-Path $env:TEMP "$packageName.$Version"

$WebFileArgs = @{
   packageName  = $packageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/win64/MCR_R2016a_win64_installer.exe'
   Checksum64   = 'e21cc004df31e405014261457c58fab3af66b3f10b1c19a9d8b78ae08424c078'
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
   URL64bit       = 'https://ssd.mathworks.com/supportfiles/downloads/R2016a/deployment_files/R2016a/installers/win64/MCR_R2016a_Update_7.exe'
   FileType       = 'exe'
   Checksum64     = '4e2f3f2614fd66948d07dc4ef04c1ae5d3ce0192020e605e3eb2cd794e7c2501'
   ChecksumType64 = 'SHA256'
   SilentArgs     = '/S'
}
Install-ChocolateyPackage @UpdateArgs