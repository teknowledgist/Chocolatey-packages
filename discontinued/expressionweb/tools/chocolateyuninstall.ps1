[array]$key = Get-UninstallRegistryKey -SoftwareName "Microsoft Expression Web*" | 
                  Where-Object {$_.UninstallString -match "msiexec"}

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      Statements      = ($key[0].UninstallString -replace '.*msiexec.exe (.*)','$1') + ' /qn'
      ExeToRun        = "$($env:SystemRoot)\System32\msiexec.exe"
      validExitCodes = @(0)
   }
   Start-ChocolateyProcessAsAdmin @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall Expression Web!"
} else {
   Write-Host "Expression Web not found.  It may have been uninstalled through other actions."
}


