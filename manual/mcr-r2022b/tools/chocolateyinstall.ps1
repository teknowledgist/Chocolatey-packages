$ErrorActionPreference = 'Stop'

$Version     = '9.13'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$Version"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2022b/Release/4/deployment_files/installer/complete/win64/MATLAB_Runtime_R2022b_Update_4_win64.zip'
   Checksum64   = 'CAFC0DF5ACFDA1DCF81387D660133F01FC7A52E8568466CFCEBA22FA01260B99'
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

