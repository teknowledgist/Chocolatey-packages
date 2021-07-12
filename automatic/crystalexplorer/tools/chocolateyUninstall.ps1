$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName "Crystal Explorer*"

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      PackageName     = $env:ChocolateyPackageName
      FileType        = 'exe'
      File            = $key[0].UninstallString
      SilentArgs      = '/S'
      validExitCodes = @(0)
   }
   Uninstall-ChocolateyPackage @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall Crystal Explorer!"
} else {
   Write-Host "Crystal Explorer not found.  It may have been uninstalled through other actions."
}

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartPrograms "$env:ChocolateyPackageName.lnk"
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the Start Menu shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}
