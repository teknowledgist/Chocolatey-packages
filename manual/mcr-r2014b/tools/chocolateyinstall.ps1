$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'mcr-r2014b'
$Version     = '8.4'
$url         = 'https://www.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/win32/MCR_R2014b_win32_installer.exe'
$url64       = 'https://www.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/win64/MCR_R2014b_win64_installer.exe'
$checkSum    = 'C3575166396F7B3F427FF5A52B99E1AD6BAD046682F04FA7DA0B5F8D1073F52C'
$checkSum64  = '6D43AB89D71374A8F864A91DD052753743202AF0BA1B13B3245D7A31813F8979'

$WorkSpace = Join-Path $env:TEMP "$packageName.$Version"

$WebFileArgs = @{
   packageName  = $packageName
   FileFullPath = Join-Path $WorkSpace 'installer.exe'
   Url          = $url
   Url64bit     = $url64
   Checksum     = $checkSum
   Checksum64   = $checkSum64
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName = $packageName
   FileFullPath = $PackedInstaller
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$Installer = (Get-ChildItem $WorkSpace -Include 'setup.exe' -Recurse).fullname

$InstallArgs = @{
   PackageName = $packageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}

Install-ChocolateyInstallPackage @InstallArgs

