$ErrorActionPreference = 'Stop'

$AppVersion = '3.4.11'   # may not match package version

$InstallArgs = @{
   packageName    = 'qgis-ltr'
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'https://qgis.org/downloads/QGIS-OSGeo4W-3.4.11-1-Setup-x86.exe'
   url64bit       = 'https://qgis.org/downloads/QGIS-OSGeo4W-3.4.11-1-Setup-x86_64.exe'
   checksumType   = 'sha256'
   checksum       = '3eeea8e42c90e36dc5fdd1de8ada11d695b8e211a928d2c4f9894a3043de2724'
   checksum64     = '7d67d6b23f2c042881a3fe0ed7289dc726a7d1cad5a69d3f8427004ee31fa777'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

$pp = Get-PackageParameters

# QGIS install is best done with older versions uninstalled
[array]$Keys = Get-UninstallRegistryKey -SoftwareName "QGIS *"
if ($Keys) {
   $TargetKey = $null
   # Only want to uninstall the latest, Long Term Release version.
   # First, gather only the versions older than this LTR package.
   [array]$Keys = $Keys | Where-Object {[version]($_.DisplayName -replace '[^0-9.]','') -le [version]$AppVersion}
   if ($Keys.Count -gt 1) {
      Write-Warning "Multiple, previously-installed Long Term Release versions of QGIS found."
      # If there are several old versions, only remove the most recent.
      $MaxVer = [version]'0.0'
      Foreach ($key in $Keys) {
         $v = [version]($key.DisplayName -replace '[^0-9.]','')
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
   $TargetVersion = $TargetKey.DisplayName -replace '[^0-9.]',''
   $TargetShortVersion = [version](([version]$TargetVersion).tostring(2))
   $AppShortVersion = [version](([version]$AppVersion).tostring(2))
   if ($pp.contains("Keep")) {
      Write-Host "You have requested for this package to NOT uninstall any previous installs of QGIS." -ForegroundColor Cyan
   }
   if ((-not $pp.contains("Keep")) -or ($TargetShortVersion -eq $AppShortVersion)) {
      if ($pp.contains("Keep")) {
         Write-warning "Multiple installs of minor (xx.yy) releases are not possible.  Version $TargetVersion will be uninstalled."
      }
      # The QGIS uninstaller sometimes leaves stuff behind that still prevents install
      Get-ChildItem HKLM:\SOFTWARE | 
                  Where-Object {$_.name -match "QGIS ?$TargetShortVersion"} |
                  Remove-Item -Recurse -Force 

      # AND it leaves behind dead, public desktop shortcuts
      if ( Test-Path "$env:PUBLIC\Desktop\QGIS $TargetShortVersion") { 
         Remove-Item "$env:PUBLIC\Desktop\QGIS $TargetShortVersion" -Recurse -Force 
      }
      $OrphanedLinks = Get-ChildItem "$env:PUBLIC\Desktop\" -Filter "*.lnk" 
      Foreach ($Item in $OrphanedLinks) {
         $LinkTarget = (new-object -comobject Wscript.Shell).CreateShortcut($Item.FullName).TargetPath
         if ($LinkTarget -match "QGIS $TargetShortVersion") {
            Remove-Item $Item.FullName -Recurse -Force 
         }
      }

      Write-Host "Uninstalling older QGIS version $TargetVersion. Please wait." -ForegroundColor Cyan
      $UninstallArgs = @{
         ExeToRun       = $TargetKey.UninstallString
         Statements     = '/S'
         ValidExitCodes = @(0)
      }
      $null = Start-ChocolateyProcessAsAdmin @UninstallArgs
      # The uninstaller starts another process and immediately returns.  
      Get-Process | Where-Object {$_.path -match '.*Temp.*chocolatey.*Au_.exe'} |wait-process
   }
}

# Finally, install.
Write-Host "Installing QGIS can take a few minutes.  Please be patient." -ForegroundColor Cyan
Install-ChocolateyPackage @InstallArgs
