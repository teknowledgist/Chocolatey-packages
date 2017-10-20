$ErrorActionPreference = 'Stop'; # stop on all errors
$SoftwareName = 'Adobe Shockwave*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $SoftwareName

if ($key.Count -eq 1) {
   $key | % { 
      $packageArgs = @{
         packageName   = $env:ChocolateyPackageName
         softwareName  = $SoftwareName
         fileType      = 'EXE'
         file          = $_.UninstallString
         silentArgs    = '/S'
         validExitCodes= @(0)
      }
      Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $($_.DisplayName)"}
}

