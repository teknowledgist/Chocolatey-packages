$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName $env:ChocolateyPackagename

if ($key.Count -eq 1) {
   # The NetTraffic installer is a per-user install.  On install, this package 
   # attempts to convert it to a machine-wide install.  However, then the 
   # default uninstall doesn't fully work.  Thus, it needs to be converted 
   # back to a per-user install even if the user is not the same user who 
   # did the initial install.
   if (Get-OSArchitectureWidth -compare 64) { 
      $SystemUninstall = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\NetTraffic' 
   } else {
      $SystemUninstall = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetTraffic'
   }
   if (Test-Path $SystemUninstall) {
      Write-Debug 'Moving uninstall registry key from machine back to user.'
      $UserUninstall = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
      Copy-Item -Path $SystemUninstall -Destination $UserUninstall -Recurse
      Remove-Item -Path $SystemUninstall -Recurse
   }
   $AllUSM = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\NetTraffic"
   if (Test-Path $AllUSM) {
      Write-Debug 'Moving Start Menu shortcuts from all users to user.'
      $UserSM = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"
      Copy-Item -Path $AllUSM -Destination $UserSM -Recurse
      Remove-Item -Path $AllUSM -Recurse
   }
} elseif ($key.Count -eq 0) {
   Write-Warning 'NetTraffic does not appear to be installed.'
} elseif ($key.Count -gt 1) {
   Write-Warning "$key.Count matches found!"
   Write-Warning 'To prevent accidental data loss, No settings will be reset.'
   $key | % {Write-Warning "- $_.DisplayName"}
}


