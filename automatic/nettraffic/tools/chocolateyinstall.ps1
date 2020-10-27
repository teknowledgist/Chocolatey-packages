$ErrorActionPreference = 'Stop'

$Checksum = 'dda5a1e6c25750be078d851d09613c17b7f735078625ad10302edf072817ee65'

# Poke/prime the CDN before download
$null = Get-WebHeaders -url 'https://www.venea.net/cdn/push/nettraffic'

# The push/pull method for this CDN does not work for Get-ChocolateyWebFile
$Destination = "$env:Temp\$env:ChocolateyPackageName\$env:ChocolateyPackageName $env:ChocolateyPackageVersion.zip"
$DownArgs = @{
   url            = 'https://www.venea.net/cdn/pull/nettraffic'
   filename       = $Destination
}
Get-Webfile @DownArgs 

Get-ChecksumValid -File $Destination -Checksum $Checksum -ChecksumType 'sha256'

$UnzipArgs = @{
   FileFullPath = $Destination
   Destination  = Split-Path $Destination
   PackageName  = $env:ChocolateyPackageName
}
Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   file           = (Get-ChildItem $UnzipArgs.Destination -filter '*.exe').fullname
   validExitCodes = @(0)
}

$pp = Get-PackageParameters
if ($pp['Launch']) { $L = '1' } Else { $L = 0 }
$InstallArgs.add('silentArgs',"/S /AUTORUN=0 /Launch=$L")
Install-ChocolateyInstallPackage @InstallArgs 

if (Get-OSArchitectureWidth -compare 64) {
   $Fx = ' (x86)'
   $Rx = '\WOW6432Node'
} else {$Fx = $Rx = ''}

# Make NetTraffic a system-wide install.  
Write-Debug 'Moving uninstall registry key from user to machine.'
$UserUninstall = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NetTraffic'
$SystemUninstall = "HKLM:\SOFTWARE$Rx\Microsoft\Windows\CurrentVersion\Uninstall\"
Copy-Item -Path $UserUninstall -Destination $SystemUninstall -Recurse
Remove-Item -Path $UserUninstall -Recurse

Write-Debug 'Moving Start Menu shortcuts from user to all users.'
$UserSM = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\NetTraffic"
$AllUSM = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\"
Copy-Item -Path $UserSM -Destination $AllUSM -Recurse
Remove-Item -Path $UserSM -Recurse

If (!$pp['AutoRun']) { 
   $RegItem = @{
      Path  = "HKLM:\SOFTWARE$Rx\Microsoft\Windows\CurrentVersion\Run"
      Name  = 'NetTraffic'
      Value = "C:\Program Files$Fx\NetTraffic\NetTraffic.exe"
      Force = $true
   }
   $null = New-ItemProperty @RegItem
}

