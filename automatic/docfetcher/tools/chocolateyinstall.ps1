$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$File = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 1

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = $File.fullname
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $File.fullname -ea 0 -force

# Make a Start Menu shortcut for all users rather that just the installing user.
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartMenu 'DocFetcher.lnk'
$InstallDir = Split-Path (Get-UninstallRegistryKey -SoftwareName "$env:ChocolateyPackageName*").uninstallstring
$Target = Join-Path $InstallDir 'DocFetcher.exe'
Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Target -WorkingDirectory "$InstallDir\lib"

# Also make the increased memory launchers usable
Copy-Item -Path "$InstallDir\misc\*.exe" -Destination $InstallDir
