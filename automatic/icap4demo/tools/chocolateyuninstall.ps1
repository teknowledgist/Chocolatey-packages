$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$QuietFile  = Join-Path $toolsDir 'ICAP4remove.iss'

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   softwareName   = 'ICAP_4Windows Demo*'
   fileType       = 'EXE'
   validExitCodes = @(0)
   silentArgs     = "/S /SMS /f1$QuietFile"
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
   $key | % { 
      $File,$Args = ($_.UninstallString).trim('"').split('"')

      $packageArgs['file'] = $File
      $packageArgs['silentArgs'] = $Args + ' ' + $packageArgs['silentArgs']

      Write-Host "Attempting 'no-reboot-necessary' uninstall method."
      Uninstall-ChocolateyPackage @packageArgs
      Start-Sleep -s 5  # The uninstaller is returning immediately despite the "/SMS" argument

      if (Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']) {
         Write-Warning "First uninstall method failed.  Attempting second method."
         Write-Warning "A reboot may be necessary to complete the uninstall."
         $packageArgs['silentArgs'] = $packageArgs['silentArgs'] -replace '\.iss$','2.iss'
         Uninstall-ChocolateyPackage @packageArgs
         Start-Sleep -s 5
      }
   }
} elseif ($key.Count -eq 0) {
   Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}


