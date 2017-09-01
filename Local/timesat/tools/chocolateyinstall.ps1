$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName  = 'TIMESAT'
$Version = '3.3'
$SharePath = '\\server\share\TIMESAT'
$Destination  = Join-Path $env:SystemDrive ($packageName + $Version.Replace('.',''))

$ZipFilePath = Join-Path $SharePath ($packageName.ToLower() + $Version.Replace('.','') + '_standalone_Win64.zip')

# This package requires MATLAB.  This will install the runtime.
$SubPackageName = 'MATLAB_Compiler_Runtime'
Get-ChocolateyUnzip $ZipFilePath $env:SystemDrive -PackageName $packageName

# Expand the installer shell
$InstallerShellFile = (Get-ChildItem $Destination -Include 'MCRinstaller.exe' -Recurse).fullname
$TempDestination = Join-Path $env:TEMP $SubPackageName
Get-ChocolateyUnzip $InstallerShellFile $TempDestination -PackageName $packageName

# Install MATLAB Runtime
$Installer = (Get-ChildItem "$TempDestination\*" -Include 'setup.exe').fullname
$InstallArgs = @{
   PackageName = $SubPackageName
   File = $Installer
   SilentArgs = '-mode silent -agreeToLicense yes'
   UseOnlyPackageSilentArguments = $true
}
Install-ChocolateyInstallPackage @InstallArgs

# Put a shortcut in the Start Menu
$target   = Join-Path (Split-Path $InstallerShellFile) ($packageName + '.exe')
$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\programs\$packageName.lnk"
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target -WorkingDirectory $Destination

# Want a shortcut on the installing user's desktop, but "System Center Software Center"
# makes that a bit more difficult to find who called it.  This is generic to any package
if ($process = gwmi win32_process -filter "name='scclient.exe'") {
   $username = $process.getowner().user
   if ($username -ne 'SYSTEM') {
      $DeskShortcut = "C:\Users\$username\Desktop\$packageName.lnk"
   } else {
      # If pushed centrally, put use the default user "Desktop\Common Applications"
      $DeskShortcut = "C:\Users\Default\Desktop\Common Applications\$packageName.lnk"
   }
} else {
   $DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) "$packageName.lnk"
}
Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target -WorkingDirectory $Destination

