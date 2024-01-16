$ErrorActionPreference = 'Stop'

$Version     = '23.2'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$Version"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2023b/Release/5/deployment_files/installer/complete/win64/MATLAB_Runtime_R2023b_Update_5_win64.zip'
   Checksum64   = 'fe8ea8d184c9c38dc56d24ea3b5b067d5a8aa7dba81a6ed3dd72cb7b76b5e6c1'
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

$Installer = (Get-ChildItem $WorkSpace -Filter 'setup.exe').fullname

$InstallArgs = @{
   PackageName = $env:ChocolateyPackageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}

Install-ChocolateyInstallPackage @InstallArgs

