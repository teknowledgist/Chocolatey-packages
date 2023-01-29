$ErrorActionPreference = 'Stop'

$Version     = '9.9'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$Version"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.zip"
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2020b/Release/8/deployment_files/installer/complete/win64/MATLAB_Runtime_R2020b_Update_8_win64.zip'
   Checksum64   = '42073DBA3701C5DFFE62B89E6376B96B59020A4B013F9ABA5EC0736B8BD5725D'
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

