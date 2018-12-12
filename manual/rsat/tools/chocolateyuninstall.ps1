$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, OperatingSystemSKU, BuildNumber
$osInfo.Version = [version]$osInfo.Version

if ($osInfo.ProductType -ne 1) {
   Write-Warning 'The Remote System Administration Toolkit (RSAT) is built into Windows Server, so it cannot be uninstalled.'
   Return
} 

If (($osInfo.Version.Major -ne 10) -or ($osInfo.BuildNumber -lt 17763)) {
   $packages = & "$env:windir\system32\dism.exe" /online /get-packages | 
                  Select-String -Pattern 'rsat|RemoteServerAdministrationTools' -AllMatches | 
                  ForEach-Object {$_.line.split(':')[-1].trim()}

   foreach ($package in $packages) {
      & "$env:windir\system32\dism.exe" /Online /Remove-Package /NoRestart /PackageName:$package
      if ($LASTEXITCODE) {
         throw "Error $LASTEXITCODE trying to remove $package`nYou may need to reboot first."
      }
   }
} else {
   # Apparently, some features must be removed after others.
   $WhereArray = @()
   $WhereArray += '($_.Name -notlike "Rsat.ActiveDirectory*")'
   $WhereArray += '($_.Name -notlike "Rsat.GroupPolicy*")'
   $WhereArray += '($_.Name -notlike "Rsat.ServerManager*")'

   $WhereString = '($_.Name -like "Rsat*") -AND ($_.State -eq "Installed") -AND ' + ($WhereArray -join ' -AND ')

   $Installed = Get-WindowsCapability -Online | Where-Object $([scriptblock]::Create($WhereString))

   foreach ($Item in $Installed) {
      try {
         Write-Host "`nRemoving $($Item.Name) from Windows"
         $DISMobject = Remove-WindowsCapability -Online -Name $Item.Name
         if ($DISMobject.RestartNeeded) {
            Write-Warning "A reboot is required."
         }
      } catch {
         Write-Warning -Message $_.Exception.Message; break
      }
   }

   # Go back and remove the rest.
   $Installed = Get-WindowsCapability -Online | Where-Object {$_.Name -like 'Rsat*' -AND $_.State -eq 'Installed'}

   foreach ($Item in $Installed) {
      try {
         Write-Host "`nRemoving $($Item.Name) from Windows"
         $DISMobject = Remove-WindowsCapability -Online -Name $Item.Name
         if ($DISMobject.RestartNeeded) {
            Write-Warning "A reboot is required."
         }
      } catch {
         Write-Warning -Message $_.Exception.Message; break
      }
   }
}

Write-Warning 'It is recommended that you restart the computer.'
