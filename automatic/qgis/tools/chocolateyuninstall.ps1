$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'QGIS *'

if ($key.Count -eq 1) {
   $oldVersion = $key[0].PSChildName -replace '.* ([0-9.]*)','$1'
   $UninstallArgs = @{
      PackageName = $env:ChocolateyPackageName
      FileType    = 'exe'
      SilentArgs  = '/S'
      File        = $key[0].UninstallString
   }
   Uninstall-ChocolateyPackage @UninstallArgs
#   $RemoveProc = Start-Process -FilePath $key[0].UninstallString -ArgumentList '/S' -PassThru
#   $updateId = $RemoveProc.Id
#   Write-Debug "Uninstall Process ID:`t$updateId"
#   $RemoveProc.WaitForExit()
} elseif ($key.Count -gt 1) {
   Throw 'Multiple, previous installs found!  For safety, no uninstall will occur.'
}

# The QGIS uninstaller sometimes leaves stuff behind
$OldKey = Get-ChildItem HKLM:\SOFTWARE | 
            Where-Object {$_.name -match 'QGIS ([0-9.]*)'} |
            Select-Object -ExpandProperty Name
if ($OldKey) {
   $oldVersion = $OldKey -replace '.*QGIS ([0-9.]*)','$1'
   Remove-Item -Path "HKLM:\Software\QGIS $oldVersion" -Recurse
}
# AND it leaves behind dead public desktop shortcuts
$OldLinks = ("QGIS $oldVersion",
            'OSGeo4W Shell.lnk',
            'GRASS GIS *.lnk')
Foreach ($item in $OldLinks) {
   if (Test-Path "$env:PUBLIC\Desktop\$item") { Remove-Item "$env:PUBLIC\Desktop\$item" -Recurse -Force }
}

