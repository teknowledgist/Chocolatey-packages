$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'http://qgis.org/downloads/QGIS-OSGeo4W-2.14.22-1-Setup-x86.exe'
   url64bit       = 'http://qgis.org/downloads/QGIS-OSGeo4W-2.14.22-1-Setup-x86_64.exe'
   checksumType   = 'sha256'
   checksum       = 'db126f9cc95df3b976bdcedd31e43b724e67e578ca611d5d950abc8bcd00ee6f'
   checksum64     = '4f2b94d41d8ea8e2516418ef974f74d36c5003503f3b32384fd2a2232f1ca69a'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

# QGIS install is best done with older versions uninstalled
[array]$key = Get-UninstallRegistryKey -SoftwareName "QGIS *"

if ($key.Count -eq 1) {
   $oldVersion = $key[0].PSChildName -replace ".* ([0-9.]*)",'$1'
   $RemoveProc = Start-Process -FilePath $key[0].UninstallString -ArgumentList '/S' -PassThru
   $updateId = $RemoveProc.Id
   Write-Host "Uninstalling old version of QGIS." -ForegroundColor Cyan
   Write-Debug "Uninstall Process ID:`t$updateId"
   $RemoveProc.WaitForExit()

   # The QGIS uninstaller sometimes leaves stuff behind that still prevents install (grr!)
   $OldKey = Get-ChildItem HKLM:\SOFTWARE | 
               Where-Object {$_.name -match "QGIS ([0-9.]*)"} |
               Select-Object -ExpandProperty Name
   if ($OldKey) {
      $oldVersion = $OldKey -replace ".*QGIS ([0-9.]*)",'$1'
      Remove-Item -Path "HKLM:\Software\QGIS $oldVersion" -Recurse
   }
   # AND it leaves behind dead public desktop shortcuts
   $OldLinks = ("QGIS $oldVersion",
               "OSGeo4W Shell.lnk",
               "GRASS GIS *.lnk")
   Foreach ($item in $OldLinks) {
      if (Test-Path "$env:PUBLIC\Desktop\$item") { Remove-Item "$env:PUBLIC\Desktop\$item" -Recurse -Force }
   }

} elseif ($key.Count -gt 1) {
   Throw "Multiple, previous installs found!  Cannot proceed with install of new version."
}

# Finally, install.
Write-Host "Installing QGIS can take a few minutes.  Please be patient." -ForegroundColor Cyan
Install-ChocolateyPackage @InstallArgs
