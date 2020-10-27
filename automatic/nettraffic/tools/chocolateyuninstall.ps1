$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'NetTraffic*'
  fileType      = 'EXE'
  silentArgs   = '/S /DELDATA=0'
  validExitCodes= @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
   $packageArgs['file'] = "$($key[0].UninstallString)"
   Uninstall-ChocolateyPackage @packageArgs
   if (Get-OSArchitectureWidth -compare 64) { 
      $RegPath = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run' 
   } else {
      $RegPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run'
   }
   if (Get-ItemProperty $RegPath -name 'nettraffic' -ea silentlycontinue) {
      $null = Remove-ItemProperty -Path $RegPath -Name 'NetTraffic' -force
   }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}


