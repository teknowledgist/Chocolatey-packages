$ErrorActionPreference = 'Stop'

$AppVersion = ''

$InstallArgs = @{
   packageName    = 'qgis-ltr'
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'http://qgis.org/downloads/QGIS-OSGeo4W-2.18.20-1-Setup-x86.exe'
   url64bit       = 'http://qgis.org/downloads/QGIS-OSGeo4W-2.18.20-1-Setup-x86_64.exe'
   checksumType   = 'sha256'
   checksum       = '169826eee6046c7da8ba67e2b7eaa273444f4a83e97a145eda0c1d2534cb4ce3'
   checksum64     = 'b0863c6f71705eb4ab09bd7087a27337b3353f3a315c798bb170389364675305'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

$pp = Get-PackageParameters

# QGIS install is best done with older versions uninstalled
[array]$Keys = Get-UninstallRegistryKey -SoftwareName "QGIS *"
$TotalInstalls = $Keys.Count
if ($Keys) {
   $TargetKey = $null
   # Only want to uninstall the latest, Long Term Release version.
   # First, gather only the versions older than this LTR package.
   [array]$Keys = $Keys | Where-Object {[version]($_.DisplayVersion) -le [version]$AppVersion}
   if ($Keys.Count -gt 1) {
      Write-Warning "Multiple, previously-installed Long Term Release versions of QGIS found."
      # If there are several old versions, only remove the most recent.
      $MaxVer = [version]'0.0'
      Foreach ($key in $Keys) {
         $v = [version]($key.DisplayVersion)
         if ($v -ge $Maxver) { 
            $MaxVer = $v 
            $TargetKey = $key
         }
      }
      if (-not $pp.contains("Keep")) {
         Write-Warning "Only the newest version (v$($MaxVer.ToString())) will be removed before installing version $AppVersion"
      }
   } elseif ($Keys.Count -eq 1) {
      $TargetKey = $Keys[0]
   }
   $TargetShortVersion = [version](([version]($TargetKey.DisplayVersion)).tostring(2))
   $AppShortVersion = [version](([version]$AppVersion).tostring(2))
   if ($pp.contains("Keep")) {
      Write-Host "You have requested for this package to NOT uninstall any previous installs of QGIS." -ForegroundColor Cyan
   }
   if ((-not $pp.contains("Keep")) -or ($TargetShortVersion -eq $AppShortVersion)) {
      if ($pp.contains("Keep") -and ($TargetShortVersion -eq $AppShortVersion)) {
         Write-warning "Multiple installs of minor (xx.yy) releases are not possible.  Version $($MaxVer.ToString()) will be uninstalled."
      }
      $RemoveProc = Start-Process -FilePath $TargetKey.UninstallString -ArgumentList '/S' -PassThru
      $updateId = $RemoveProc.Id
      Write-Host "Uninstalling QGIS version $($MaxVer.ToString())." -ForegroundColor Cyan
      Write-Debug "Uninstall Process ID:`t$updateId"
      $RemoveProc.WaitForExit()

      # The QGIS uninstaller sometimes leaves stuff behind that still prevents install (grr!)
      $OldKey = Get-ChildItem HKLM:\SOFTWARE | 
                  Where-Object {$_.name -match "QGIS ?$($MaxVer.tostring(2))"} |
                  Select-Object -ExpandProperty Name
      if ($OldKey) { $OldKey | Remove-Item -Recurse }

      # AND it leaves behind dead, public desktop shortcuts
      $OldLinks = [array]("QGIS $TargetShortVersion")
      if ($TotalInstalls -eq 1) {
         $OldLinks += 'OSGeo4W Shell.lnk','GRASS GIS *.lnk'
      } elseif ($TotalInstalls -gt 1) {
         if (Test-Path "$env:PUBLIC\Desktop\QGIS $TargetShortVersion") {
            $GRASSversion = (Get-ChildItem "$env:PUBLIC\Desktop\QGIS $TargetShortVersion" -Filter "*GRASS*" | 
                              Select-Object -ExpandProperty Name -First 1) -replace ".*GRASS ([0-9.]+).lnk",'$1'
            $OldLinks += "GRASS GIS $GRASSversion.lnk",'OSGeo4W Shell.lnk'
         }
      }
      Foreach ($item in $OldLinks) {
         if (Test-Path "$env:PUBLIC\Desktop\$item") { 
            Remove-Item "$env:PUBLIC\Desktop\$item" -Recurse -Force 
         }
      }
   }
}

# Finally, install.
Write-Host "Installing QGIS can take a few minutes.  Please be patient." -ForegroundColor Cyan
Install-ChocolateyPackage @InstallArgs
