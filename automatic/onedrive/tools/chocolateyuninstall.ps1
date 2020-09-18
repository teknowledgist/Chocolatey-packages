$ErrorActionPreference = 'Stop'

# Restore the per-user install of the built-in OneDrive (if it was there)
if (Test-Path "$env:ChocolateyPackageFolder\Removed.reg") {
   REG LOAD HKLM\DefaultUser "$env:SystemDrive\Users\Default\NTUSER.DAT"
   Start-sleep 1   # avoiding a race condition
   REG IMPORT "$env:ChocolateyPackageFolder\Removed.reg"
   Start-sleep 1   # avoiding a race condition
   REG UNLOAD HKLM\DefaultUser
   Write-Verbose "Previous registry key restored."
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  silentArgs    = '/uninstall /allusers'
  validExitCodes= @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object { 
    $packageArgs['file'] = "$($_.UninstallString.split('/')[0])"
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}


