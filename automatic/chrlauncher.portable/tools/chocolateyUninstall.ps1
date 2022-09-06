$ErrorActionPreference = 'Stop'  # stop on all errors

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# If ChrLauncher was made the default browser, turn that off
if (Test-Path 'HKLM:\Software\Clients\StartMenuInternet\chrlauncher') {
$version = (get-childitem -filter "chrlauncher*" | 
               Where-Object {$_.psiscontainer} | 
               ForEach-Object {[version]($_.name -replace 'chrlauncher','')} |
               Sort-Object)[-1]
$InstallDir = join-path $PackageFolder "chrlauncher$($version.tostring())"
$BitLevel = Get-ProcessorBits
   Write-Debug 'Removing registry keys that set chrlauncher as the default browser.'
   $Regfile = Join-Path $InstallDir "$BitLevel\RegistryCleaner.reg"
   regedit /s $Regfile
}

$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Chromium Launcher.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug 'Found the desktop shortcut. Deleting it...'
    [System.IO.File]::Delete($shortcut)
}

