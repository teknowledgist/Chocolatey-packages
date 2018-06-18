$ErrorActionPreference = 'Stop'

$AppShortVersion = [version](([version]$env:ChocolateyPackageVersion).tostring(2))

[array]$key = Get-UninstallRegistryKey -SoftwareName "QGIS $AppShortVersion*"

if ($key.Count -eq 1) {
   $oldVersion = $key[0].PSChildName -replace '([^0-9.]+)','$1'
   $UninstallArgs = @{
      PackageName = $env:ChocolateyPackageName
      FileType    = 'exe'
      SilentArgs  = '/S'
      File        = $key[0].UninstallString
   }
   Uninstall-ChocolateyPackage @UninstallArgs

} elseif ($key.Count -gt 1) {
   Throw 'Multiple, previous installs found!  For safety, no uninstall will occur.'
}

# The QGIS uninstaller sometimes leaves stuff behind
$OldKey = Get-ChildItem HKLM:\SOFTWARE | 
            Where-Object {$_.name -match "QGIS $AppShortVersion"} |
            Select-Object -ExpandProperty Name
if ($OldKey) { $OldKey | Remove-Item -Recurse }

# AND it leaves behind dead, public desktop shortcuts
$OldLinks = [array]("QGIS $AppShortVersion")
if (Test-Path "$env:PUBLIC\Desktop\QGIS $AppShortVersion") {
   $GRASSversion = (Get-ChildItem "$env:PUBLIC\Desktop\QGIS $AppShortVersion" -Filter "*GRASS*" | 
                     Select-Object -ExpandProperty Name -First 1) -replace ".*GRASS ([0-9.]+).lnk",'$1'
   $OldLinks += "GRASS GIS $GRASSversion.lnk",'OSGeo4W Shell.lnk'
}
Foreach ($item in $OldLinks) {
   if (Test-Path "$env:PUBLIC\Desktop\$item") { 
      Remove-Item "$env:PUBLIC\Desktop\$item" -Recurse -Force 
   }
}

