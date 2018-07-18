$packageName  = 'crystalexplorer'
$FriendlyName = 'Crystal Explorer'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$FriendlyName*"

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
   Throw "Multiple installs found.  Could not safely uninstall $FriendlyName!"
} else {
   Write-Host "$FriendlyName not found.  It may have been uninstalled through other actions."
}
