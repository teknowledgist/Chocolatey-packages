$ErrorActionPreference = 'Stop'   # stop on all errors

$PackageName = 'mcr-r2016a'
$Version = '9.0.1'
$softwareName = "MATLAB Runtime $Version"


[array]$key = Get-UninstallRegistryKey -SoftwareName "$SoftwareName*"]


if ($key.Count -eq 1) {
   $key | % { 

      $Uninstaller = ("$($_.UninstallString)" -split '.exe ')[0]
      $InstalledPath = ("$($_.UninstallString)" -split '.exe ')[1]

      $packageArgs = @{
        packageName   = $PackageName
        softwareName  = "$softwareName*"
        file          = "$Uninstaller.exe"
        fileType      = 'EXE'
        silentArgs   = "$InstalledPath -mode silent"
        validExitCodes= @(0)
      }
      Uninstall-ChocolateyPackage @packageArgs

      if (Test-Path $InstalledPath) {
         Remove-Item $InstalledPath -Recurse -Force
      }
  }
} elseif ($key.Count -eq 0) {
   Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}


