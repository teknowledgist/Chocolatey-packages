$ErrorActionPreference = 'Stop'

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version,ProductType

if ($osInfo.ProductType -ne 1) {
   Write-Warning 'The Remote System Administration Toolkit (RSAT) is built into Windows Server, so it cannot be uninstalled.'
   Return
} 

if (([version]$osInfo.Version).Major -eq 6) {
   $string = 'RemoteServerAdministrationTools'
} 
else {
   $string = 'rsat'
}

$packages = dism /online /get-packages | 
               Select-String -Pattern $string -AllMatches | 
               ForEach-Object {$_.line.split(':')[-1].trim()}

foreach ($package in $packages) {
   DISM /Online /Remove-Package /NoRestart /PackageName:$package
}

Write-Warning 'It is recommended that you restart the computer.'
