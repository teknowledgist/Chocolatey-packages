$PackageName = 'chrlauncher.portable'
$version = '2.3'
$PackageDir = Split-path (Split-path $MyInvocation.MyCommand.Definition)
$InstallDir = (Join-path $PackageDir ($PackageName.split('.')[0] + $version))
$BitLevel = Get-ProcessorBits

if (Test-Path 'HKLM:\Software\Clients\StartMenuInternet\chrlauncher') {
   Write-Debug 'Removing registry keys that set chrlauncher as the default browser.'
   $Regfile = Join-Path $InstallDir "$BitLevel\RegistryCleaner.reg"
   regedit /s $Regfile
}

Remove-Item $InstallDir -Recurse -Force

$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Chromium Launcher.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug 'Found the desktop shortcut. Deleting it...'
    [System.IO.File]::Delete($shortcut)
}

