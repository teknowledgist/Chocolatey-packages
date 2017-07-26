$commonName = 'StataSE'

$v    = ([version]$ChocolateyPackageVersion).major

[array]$key = Get-UninstallRegistryKey -SoftwareName "Stata $v"

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      Statements      = ($key[0].UninstallString -replace '.*msiexec.exe (.*)','$1') + ' /qn'
      ExeToRun        = "$($env:SystemRoot)\System32\msiexec.exe"
      validExitCodes = @(0)
   }
   Start-ChocolateyProcessAsAdmin @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw "Multiple installs found.  Could not safely uninstall Stata $v!"
} else {
   Write-Host "Stata $v not found.  It may have been uninstalled through other actions."
}

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcut = Join-Path $desktop "$commonName $v.lnk"
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug 'Found the desktop shortcut. Deleting it...'
    [System.IO.File]::Delete($shortcut)
}
