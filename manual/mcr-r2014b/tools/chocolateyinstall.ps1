$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url          = 'https://www.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/win32/MCR_R2014b_win32_installer.exe'
   Url64bit     = 'https://www.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/win64/MCR_R2014b_win64_installer.exe'
   Checksum     = 'C3575166396F7B3F427FF5A52B99E1AD6BAD046682F04FA7DA0B5F8D1073F52C'
   Checksum64   = '6D43AB89D71374A8F864A91DD052753743202AF0BA1B13B3245D7A31813F8979'
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
