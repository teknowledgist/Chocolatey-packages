$ErrorActionPreference = 'Stop'

$SoftwareName = "MATLAB Runtime $env:ChocolateyPackageVersion"

[array]$key = Get-UninstallRegistryKey -SoftwareName $SoftwareName

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      packageName    = $env:ChocolateyPackageName
      softwareName   = $SoftwareName
      fileType       = 'exe'
      file           = $key[0].UninstallString -replace '(.*\.exe).*','$1'
      silentArgs     = '"' + $key[0].InstallLocation + '" -mode silent'
      validExitCodes = @(0)
   }
   Uninstall-ChocolateyPackage @UninstallArgs
   if (Test-Path $key[0].InstallLocation) {
      Remove-Item $key[0].InstallLocation -Recurse
   }
} elseif ($key.Count -eq 0) {
   Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}

