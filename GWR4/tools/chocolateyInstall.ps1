$InstallArgs = @{
   packageName = 'gwr4'
   installerType = 'exe'
   url = 'https://raw.githubusercontent.com/gwrtools/gwr4/master/GWR408_setup_win32.exe'
   url64bit = 'https://raw.githubusercontent.com/gwrtools/gwr4/master/GWR408_setup_win64.exe'
   silentArgs = '/s /a /s /v"/quiet"'
   validExitCodes = @(0)
}

Install-ChocolateyPackage @InstallArgs

$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory))

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $desktop 'GWR4.lnk'
   TargetPath = Join-Path $env:ProgramFiles 'GWR4\sgwrwin.exe'
   WorkingDirectory = Join-Path $env:ProgramFiles 'GWR4'
}

Install-chocolateyShortcut.ps1 @ShortcutArgs
