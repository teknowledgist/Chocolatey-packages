$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -eq 'Avogadro'} |
                     Select-Object -ExpandProperty UninstallString


$UninstallArgs = @{
   packageName = 'avogadro'
   fileType = 'exe'
   file = $unexe
   silentArgs = '/S'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs




