$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'http://qgis.org/downloads/QGIS-OSGeo4W-3.0.3-1-Setup-x86.exe'
   url64bit       = 'http://qgis.org/downloads/QGIS-OSGeo4W-3.0.3-1-Setup-x86_64.exe'
   checksumType   = 'sha256'
   checksum       = 'e3e46ea832c1a80974d551bd0b2f1ad56aba3f029096781b57cf476b87ce92c6'
   checksum64     = '95f5b5363c379d3a9d1db9f30e7faf763d1e9db2af9951e5be9c5a87c172c7cf'
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
