$ErrorActionPreference = 'Stop'

$NewRelease = $env:ChocolateyPackageVersion
$LTRversion = '3.10.10'

$InstallArgs = @{
   packageName    = 'qgis'
   fileType       = 'EXE'
   softwareName   = "$env:ChocolateyPackageName $env:ChocolateyPackageVersion*"
   url            = 'https://qgis.org/downloads/QGIS-OSGeo4W-3.14.16-2-Setup-x86.exe'
   url64bit       = 'https://qgis.org/downloads/QGIS-OSGeo4W-3.14.16-2-Setup-x86_64.exe'
   checksumType   = 'sha256'
   checksum       = '0588a57e30a01f4562996fe10a5e1a333566c29ca90ada66309dd3c2c907795a'
   checksum64     = 'e317675fdcd3f2837705fdf5b5658b0f5dc395f490ccd7b8f55c63ee22091391'
   silentArgs     = '/S'
   validExitCodes = @(0)
}

$pp = Get-PackageParameters

# QGIS install is best done with older versions uninstalled
[array]$Keys = Get-UninstallRegistryKey -SoftwareName "QGIS *"
if ($Keys) {
   $TargetKey = $null
   if ($Keys.Count -gt 1) {
      Write-Warning "Multiple, previously-installed versions of QGIS found."
      # Find the most recent version
      $TargetVersion = [version]'0.0'
      Foreach ($key in $Keys) {
         $v = [version]($key.DisplayName -replace '[^0-9.]','')
         if ($v -ge $TargetVersion) { 
            $TargetVersion = $v 
            $TargetKey = $key
         }
      }
   } elseif ($Keys.Count -eq 1) {
      $TargetKey = $Keys[0]
      $TargetVersion = [version]($TargetKey.DisplayName -replace '[^0-9.]','')
   }

   $PkgShortVersion = [version](([version]$env:ChocolateyPackageVersion).tostring(2))

   If ($TargetVersion -le [version]$LTRversion) {
      # Want to avoid removing QGIS-LTR package installs
      if (Test-Path ($env:ChocolateyPackageFolder + "-ltr")) {
         $nuspec = Get-ChildItem ($env:ChocolateyPackageFolder + "-ltr") -Filter "*.nuspec" | Select-Object -First 1
         $text = (Get-Content $nuspec.fullname | Select-String '<version>[0-9.]*</version>').Matches.Value
         $LTRPkgShortVer = [version]([version]($text -replace '[^0-9.]','').ToString(2))
         if ($LTRPkgShortVer -ge [version]($TargetVersion.tostring(2))) {
            # QGIS may have changed major.minor version.  
            # If newest install conflicts with LTR install don't uninstall.
            $TargetKey = $null
            If ($LTRPkgShortVer -ge $PkgShortVersion) {
               Throw ("QGIS package must be newer than any QGIS-LTR package installed!`n" +
                        "`tInstalled QGIS-LTR version:  $LTRPkgShortVer.x`n")
            }
         }
      }
   }
}
if ($TargetKey) {
   $TargetShortVersion = [version](([version]$TargetVersion).tostring(2))
   if ($pp.contains("Keep")) {
      Write-Host "You have requested for this package to NOT uninstall any previous installs of QGIS." -ForegroundColor Cyan
   }
   if ((-not $pp.contains("Keep")) -or ($TargetShortVersion -eq $PkgShortVersion)) {
      if ($pp.contains("Keep")) {
         Write-warning "Multiple installs of minor (xx.yy) releases are not possible.  Version $TargetVersion will be uninstalled."
      }
      Write-Host "Uninstalling older QGIS version $TargetVersion. Please wait." -ForegroundColor Cyan

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
