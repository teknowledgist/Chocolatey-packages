$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'xplorer*lite 32 bit'
   fileType      = 'EXE'
   silentArgs    = '/S'
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
   $key | % { 
      $packageArgs['file'] = "$($_.UninstallString)"

      # silent uninstall requires AutoHotKey
      $toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
      $ahkFile = Join-Path $toolsDir 'chocolateyUninstall.ahk'
      $ahkProc = Start-Process -FilePath AutoHotkey -ArgumentList "$ahkFile" -PassThru
      Write-Debug "AutoHotKey start time:`t$($ahkProc.StartTime.ToShortTimeString())"
      Write-Debug "AutoHotKey Process ID:`t$($ahkProc.Id)"

      Uninstall-ChocolateyPackage @packageArgs
   }
} elseif ($key.Count -eq 0) {
   Write-Warning "$env:ChocolateypackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}
