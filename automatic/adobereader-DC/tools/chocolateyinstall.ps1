$ErrorActionPreference = 'Stop'

$DisplayName = 'Adobe Acrobat Reader DC MUI'

$MUIurl            = ''
$MUIchecksum       = ''
$MUImspURL         = ''
$MUImspChecksum    = ''

$MUIinstalled = $false
$UpdateOnly = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $DisplayName.replace(' MUI','*')

if ($key.Count -eq 1) {
   $InstalledVersion = $key[0].DisplayVersion.replace('.','')
   $InstallerVersion = (Split-Path $MUIurl -Leaf) -replace '[^0-9]',''
   if ($key[0].DisplayName -notmatch 'MUI') {
      if ($InstalledVersion -ge $InstallerVersion) {
         Write-Warning "The currently installed $($key[0].DisplayName) is a single-language install."
         Write-Warning "This multi-language (MUI) package cannot overwrite it at this time."
         Write-Warning "You will need to uninstall $($key[0].DisplayName) first."
         Throw "Installation halted."
      } else {
         Write-Warning "The currently installed $($key[0].DisplayName) is a single-language install."
         Write-Warning  "This package will replace it with the multi-language (MUI) release."
      }
   } else {
      $MUIinstalled = $true
      $UpdaterVersion = (Split-Path $MUImspURL -Leaf) -replace '[^0-9]',''
      if ($InstalledVersion -eq $UpdaterVersion) {
         Write-Verbose "Currently installed version is the same as this package.  Nothing further to do."
         Return
      } elseif ($InstalledVersion -gt $UpdaterVersion) {
         Write-Warning "$($key[0].DisplayName) v20$($key[0].DisplayVersion) installed."
         Write-Warning "This package installs v$env:ChocolateyPackageVersion and cannot replace a newer version."
         Throw "Installation halted."
      } elseif (($InstalledVersion -ge $InstallerVersion) -and ($InstalledVersion -lt $UpdaterVersion)) {
         $UpdateOnly = $true
      }
   }
} elseif ($key.count -gt 1) {
   Write-Warning "$($key.Count) matching installs of Adobe Acrobat Reader DC found!"
   Write-Warning "To prevent accidental data loss, this install will be aborted."
   Write-Warning "The following installs were found:"
   $key | % {Write-Warning "- $($_.DisplayName)`t$($_.DisplayVersion)"}
   Throw "Installation halted."
}

$PackageParameters   = Get-PackageParameters
# Reference: https://www.adobe.com/devnet-docs/acrobatetk/tools/AdminGuide/properties.html#command-line-example
$options = ' DISABLEDESKTOPSHORTCUT=1'
if ($PackageParameters.DesktopIcon) {
   $options += ''
   Write-Host 'You requested a desktop icon.' -ForegroundColor Cyan
}

if ($PackageParameters.NoUpdates) {
   $RegRoot = 'HKLM:\SOFTWARE\Policies'
   $RegSubFolders = ('Adobe\Acrobat Reader\DC\FeatureLockDown').split('\')
   for ($i=0; $i -lt $RegSubFolders.count; $i++) {
      $RegPath = "$RegRoot\$($RegSubFolders[0..$i] -join '\')"
      if (-not (Test-Path $RegPath)) {
         $null = New-Item -Path $RegPath.TrimEnd($RegSubFolders[$i]) -Name $RegSubFolders[$i]
      }
   }
   $RegPath = "$RegRoot\$($RegSubFolders -join '\')"
   if (Test-Path $RegPath) {
      $null = New-ItemProperty -Path $RegPath -Name 'bUpdater' -PropertyType DWORD -Value 0 -Force
   }
   Write-Host 'You requested no Adobe updates.' -ForegroundColor Cyan
}

if ($PackageParameters.EnableUpdateService) {
   Write-Host 'You requested to enable the auto-update service.' -ForegroundColor Cyan
} else {
   $options += ' DISABLE_ARM_SERVICE_INSTALL=1'
   $null = Stop-Service "AdobeARMservice" -force
   $null = Set-Service "AdobeARMservice" -StartupType Disabled
}

if (-not $PackageParameters.UpdateMode) {
   $UpdateMode = 0
} else {$UpdateMode = $PackageParameters.UpdateMode}

if ((0..4) -contains $UpdateMode) {
   if ($MUIinstalled) {
      $RegPath1 = 'HKLM:\SOFTWARE\Adobe\Adobe ARM\1.0\ARM\'
      if (Test-Path $RegPath1) {
         $null = New-ItemProperty -Path $RegPath1 -Name ' iCheckReader' -Value $UpdateMode -force
      }
      $RegPath2 = 'HKLM:\SOFTWARE\Wow6432Node\Adobe\Adobe ARM\Legacy\Reader\{AC76BA86-7AD7-FFFF-7B44-AC0F074E4100}'
      if (Test-Path $RegPath2) {
         $null = New-ItemProperty -Path $RegPath2 -Name ' iCheckReader' -Value $UpdateMode -force
      }
   } else {
      $options += " UPDATE_MODE=$UpdateMode"
      Switch ($UpdateMode) {
         0 { Write-Host 'You requested manual update checks and installs.' -ForegroundColor Cyan }
         1 { Write-Host 'You requested manual update checks and installs.' -ForegroundColor Cyan }
         2 { Write-Host 'You requested automatic update downloads and manual installs.' -ForegroundColor Cyan }
         3 { Write-Host 'You requested scheduled, automatic updates.' -ForegroundColor Cyan }
         4 { Write-Host 'You requested notifications but manual updates.' -ForegroundColor Cyan }
      }
   }
}

if (-not $UpdateOnly) {
   $packageArgsEXE = @{
      packageName    = $env:ChocolateyPackageName
      fileType       = 'EXE'
      url            = $MUIurl
      checksum       = $MUIchecksum
      checksumType   = 'SHA256'
      silentArgs     = "/sAll /msi /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES $options" +
                        " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Install.log`""
      validExitCodes = @(0, 1000, 1101, 1603)
   }
   $exitCode = Install-ChocolateyPackage @packageArgsEXE
   
   if ($exitCode -eq 1603) {
      Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
      Throw "Installation of $env:ChocolateyPackageName was unsuccessful."
   }
}

$DownloadArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:ChocolateyPackageVersion.msp"
   url            = $MUImspURL
   checksum       = $MUImspChecksum
   checksumType   = 'SHA256'
   GetOriginalFileName = $true
}
$mspPath = Get-ChocolateyWebFile @DownloadArgs

$UpdateArgs = @{
   Statements     = "/p $mspPath /norestart /quiet ALLUSERS=1 EULA_ACCEPT=YES $options" +
                        " /L*v `"$env:TEMP\$env:chocolateyPackageName.$env:chocolateyPackageVersion.Update.log`""
   ExetoRun       = 'msiexec.exe'
   validExitCodes = @(0, 1603)
}
$exitCode = Start-ChocolateyProcessAsAdmin @UpdateArgs
if ($exitCode -eq 1603) {
   Write-Warning "For code 1603, Adobe recommends to 'shut down Microsoft Office and all web browsers' and try again."
   Throw "Installation of $env:ChocolateyPackageName was unsuccessful."
}



if ($PackageParameters.EnableAutoUpdate) {
    SchTasks /Change /Enable /TN "Adobe Acrobat Update Task" | Out-Null
    Set-Service "AdobeARMservice" -StartupType Automatic | Out-Null
    Start-Service "AdobeARMservice" | Out-Null
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" `
        -Name "bUpdater" `
        -Type DWORD `
        -Value 1 `
        -Message "Enable Update Button"
} else {
    Update-RegistryValue `
        -Path "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" `
        -Name "bUpdater" `
        -Type DWORD `
        -Value 0 `
        -Message "Disable Update Button"    
    SchTasks /Change /Disable /TN "Adobe Acrobat Update Task" | Out-Null
    Stop-Service "AdobeARMservice" -force | Out-Null
    Set-Service "AdobeARMservice" -StartupType Disabled | Out-Null
}
