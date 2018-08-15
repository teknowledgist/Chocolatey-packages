$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url          = 'https://ssd.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/win32/MCR_R2015a_win32_installer.exe'
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/win64/MCR_R2015a_win64_installer.exe'
   Checksum     = '109f90312e467a101d0dd9787a1fbcb3ea38a07f32a7b960dfd4cfa1b7ad00a6'
   Checksum64   = '6e265e0619851a86baa5f5edcae836cc68046977ecb00eeb6085e5a4f98ff812'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$msgtext = 'MATLAB Runtime is large, so it may take awhile to download and install.  Please be patient.'
Write-Host $msgtext -ForegroundColor Cyan

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$Installer = (Get-ChildItem $WorkSpace -Include 'setup.exe' -Recurse).fullname

$InstallArgs = @{
   PackageName = $env:ChocolateyPackageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}

Install-ChocolateyInstallPackage @InstallArgs

