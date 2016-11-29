$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -eq 'OpenChrom'} |
                     Select-Object -ExpandProperty UninstallString

$UninstallArgs = @{
   packageName = 'openchrom'
   fileType = 'exe'
   file = $unexe
   silentArgs = '/S'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs




