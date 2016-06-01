# This really can't be installed without AutoHotKey as a prereq.

$packageName = 'fastcopy.install'

$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$PackageDir = Split-Path $ScriptDir

# Win7 complains the installer didn't run correctly.  This will prevent that.
Set-Variable __COMPAT_LAYER=!Vista

& AutoHotkey.exe $(Join-Path $ScriptDir 'chocolateyUninstall.ahk')
& $(Join-Path $env:ProgramFiles 'FastCopy\setup.exe')

# It's not clear what uninstall does, but it does not remove the application.
if (Test-Path (Join-Path $env:ProgramFiles 'FastCopy')) {
  Remove-Item (Join-Path $env:ProgramFiles 'FastCopy') -Recurse -Force
} else {
  throw 'FastCopy install not found!'
}
