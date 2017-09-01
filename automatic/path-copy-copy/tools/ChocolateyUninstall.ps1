$packageName  = 'path-copy-copy'
$SoftwareName = 'Path Copy Copy'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$SoftwareName*"

# Installing v14 over previous MSI-wrapped installs leaves two "install" items.
# Removing either appears to remove both.
if ($key.Count -ge 1) {
   $UninstallArgs = @{
      PackageName     = $packageName
      FileType        = 'exe'
      File            = $key[0].UninstallString
      SilentArgs      = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
      validExitCodes = @(0)
   }
   Uninstall-ChocolateyPackage @UninstallArgs

} else {
   Write-Host "$SoftwareName not found.  It may have been uninstalled through other actions."
}
