$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Asymptote*'
  fileType      = 'EXE'
  silentArgs   = '/S'
  validExitCodes= @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
   $packageArgs['file'] = "$($key[0].UninstallString)"
   Uninstall-ChocolateyPackage @packageArgs
   $AllUSM = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Asymptote"
   if (Test-Path $AllUSM) {
      Remove-Item -Path $AllUSM -Recurse
   }
   Start-Sleep 1
   if (Get-Process 'un_A') { Get-Process 'un_A' | Stop-Process }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
}

