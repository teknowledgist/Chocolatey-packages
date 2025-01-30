$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName "PDF24*"

if ($key.Count -eq 1) {
   $GUID = "{$($key[0].UninstallString.split('{')[-1])"
   $UninstallArgs = @{
      Statements    = "/x $GUID /qn /norestart /l*v `"$($env:TEMP)\$($env:chocolateyPackageName).$($env:chocolateyPackageVersion).Uninstall.log`""
      ExeToRun      = 'msiexec'
      validExitCodes= @(0, 93, 3010, 1605, 1614, 1641)
   }
   Start-ChocolateyProcessAsAdmin @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall PDF24!"
} else {
   Write-Host "PDF24 not found.  It may have been uninstalled through other actions."
}

if (Test-Path 'HKLM:\SOFTWARE\PDF24') {
   Remove-Item 'HKLM:\SOFTWARE\PDF24' -Recurse -Force
}
