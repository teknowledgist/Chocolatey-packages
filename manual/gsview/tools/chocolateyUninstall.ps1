$packageName='GSView'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$packageName*"

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      PackageName     = $packageName
      FileType        = 'exe'
      File            = $key[0].UninstallString
      SilentArgs      = '/S'
      validExitCodes = @(0)
   }
   Uninstall-ChocolateyPackage @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall $packageName!"
} else {
   Write-Host "$packageName not found.  It may have been uninstalled through other actions."
}

