$ErrorActionPreference = 'Stop'

$packageArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'xplorer² Pro*'
   fileType      = 'EXE'
   silentArgs    = ''
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
   $packageArgs['file'] = "$($key[0].UninstallString.trim('"'))"
   
   $pp = Get-PackageParameters
   if ($pp["Keep"]) {
      Write-Host 'Uninstall will NOT remove xplorer² Pro registry settings or bookmarks.' -ForegroundColor Cyan
      $ahkArgs = '2'
   } else {
      Write-Host 'Uninstall WILL remove xplorer² Pro registry settings and bookmarks.' -ForegroundColor Cyan
      $ahkArgs = '1'
   }
   $ahkArgs = "$(Get-OSArchitectureWidth) $ahkArgs"

   $ahkExe = 'AutoHotKey'
   $toolsDir    = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
   $ahkFile = Join-Path $toolsDir 'chocolateyUninstall.ahk'
   $ahkProc = Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkFile`" $ahkArgs" -PassThru
   $ahkId = $ahkProc.Id
   Write-Debug "$ahkExe start time:`t$($ahkProc.StartTime.ToShortTimeString())"
   Write-Debug "Process ID:`t$ahkId"
      
   Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
   Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}
