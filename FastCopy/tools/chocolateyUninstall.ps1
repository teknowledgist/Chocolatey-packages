# This really can't be installed without AutoHotKey as a prereq.

$packageName = 'fastcopy'

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$PackageDir = Split-Path $ScriptDir

$InstallArgs = @{
   packageName = $packageName
   installerType = 'exe'
   url = 'http://ftp.vector.co.jp/66/88/2323/FastCopy313.zip'
   url64bit = 'http://ftp.vector.co.jp/66/88/2323/FastCopy313_x64.zip'
   unzipLocation = Join-Path $PackageDir $packageName
   validExitCodes = @(0)
}

Install-ChocolateyZipPackage @InstallArgs

# Win7 complains the installer didn't run correctly.  This will prevent that.
Set-Variable __COMPAT_LAYER=!Vista

& AutoHotKey $(Join-Path $ScriptDir 'chocolateyInstall.ahk')
& $(Join-Path $InstallArgs.unzipLocation 'setup.exe')

