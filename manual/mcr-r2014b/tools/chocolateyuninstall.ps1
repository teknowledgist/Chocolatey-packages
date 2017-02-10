$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'mcr-r2014b'
$softwareName = 'MATLAB Compiler Runtime R2014b'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $key | % { 
    $file = "$($_.UninstallString)"

    $Args = @{
      PackageName    = $packageName
      FileType       = 'exe'
      SilentArgs     = '-mode silent'
      ValidExitCodes = @(0)
      File           = $file
    }
    Uninstall-ChocolateyPackage @Args
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$key.Count matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | % {Write-Warning "- $_.DisplayName"}
}

