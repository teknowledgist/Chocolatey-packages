$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version,ProductType

if ($osInfo.ProductType -ne 1) {
   Write-Warning 'The Remote System Administration Toolkit (RSAT) is built into Windows Server, so it cannot be uninstalled.'
   Return
} 

$packages = dism /online /get-packages | 
               Select-String -Pattern 'rsat|RemoteServerAdministrationTools' -AllMatches | 
               ForEach-Object {$_.line.split(':')[-1].trim()}

foreach ($package in $packages) {
   DISM /Online /Remove-Package /NoRestart /PackageName:$package
   if ($LASTEXITCODE) {
      throw "Error $LASTEXITCODE trying to remove $package`nYou may need to reboot first."
   }
}

Write-Warning 'It is recommended that you restart the computer.'
