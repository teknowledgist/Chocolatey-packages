$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'encifer'} |
                     Select-Object -ExpandProperty UninstallString


$UninstallArgs = @{
   packageName = 'encifer'
   fileType = 'exe'
   file = $unexe
   silentArgs = '--mode unattended'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs





