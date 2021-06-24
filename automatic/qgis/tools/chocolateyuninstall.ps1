$ErrorActionPreference = 'Stop'

$AppShortVersion = ([version]$env:ChocolateyPackageVersion).tostring(2)

[array]$key = Get-UninstallRegistryKey -SoftwareName "QGIS $AppShortVersion*"

if ($key.Count -eq 1) {
   $UninstallArgs = @{
      PackageName    = $env:ChocolateyPackageName
      ValidExitCodes = @(0)
   }
   if ($key.UninstallString -match '\.exe$') {
      $UninstallArgs.File       = $key.UninstallString
      $UninstallArgs.FileType   = 'EXE'
      $UninstallArgs.SilentArgs = '/S'
   } else {
      $ID = ($key.UninstallString -split '/x')[-1]
      $UninstallArgs.File       = 'msiexec.exe'
      $UninstallArgs.FileType   = 'MSI'
      $UninstallArgs.SilentArgs = "$ID /qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$AppShortVersion.MsiUninstall.log`""
   }
   Uninstall-ChocolateyPackage @UninstallArgs

   # The uninstaller starts an "Au_" process and immediately returns.  
   Write-Host "Despite the line above, $env:ChocolateyPackageName is still uninstalling.  Please wait." -ForegroundColor Cyan
   Get-Process | Where-Object {$_.path -match '.*Temp.*chocolatey.*Au_.exe'} | Wait-Process

   # The QGIS uninstaller sometimes leaves stuff behind
   Get-ChildItem HKLM:\SOFTWARE | 
               Where-Object {$_.name -match "QGIS $AppShortVersion"} | 
               Remove-Item -Recurse -Force 

   # AND it leaves behind dead, public desktop shortcuts
   if (Test-Path "$env:PUBLIC\Desktop\QGIS $AppShortVersion") { 
      Remove-Item "$env:PUBLIC\Desktop\QGIS $AppShortVersion" -Recurse -Force 
   }
   $OrphanedLinks = Get-ChildItem "$env:PUBLIC\Desktop\" -Filter "*.lnk" 
   Foreach ($Item in $OrphanedLinks) {
      $LinkTarget = (new-object -comobject Wscript.Shell).CreateShortcut($Item.FullName).TargetPath
      if ($LinkTarget -match "QGIS $AppShortVersion") {
         Remove-Item $Item.FullName -Recurse -Force 
      }
   }

} elseif ($key.Count -gt 1) {
   Throw 'Multiple, previous installs found!  For safety, no uninstall will occur.'
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName $AppShortVersion has already been uninstalled by other means."
}


