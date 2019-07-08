$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url          = 'https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/win32/MCR_R2015b_win32_installer.exe'
   Url64bit     = 'https://ssd.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/win64/MCR_R2015b_win64_installer.exe'
   Checksum     = '74593c18b69c5abc0f72eb61ce28a85240fe567fd3b22e7bc4b7dda1251986e2'
   Checksum64   = 'dd5eb527ed16cd029cc135ca6fffc80a40d7c402d01cec7deec88641f809d30b'
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

$Installer = (Get-ChildItem -Path "$WorkSpace\bin" -Include 'setup.exe' -Recurse).fullname

$InstallArgs = @{
   PackageName = $env:ChocolateyPackageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}

Install-ChocolateyInstallPackage @InstallArgs

