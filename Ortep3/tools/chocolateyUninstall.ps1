$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'ortep'} |
                     Select-Object -ExpandProperty UninstallString

$UninstallArgs = @{
   packageName = 'ortep3'
   fileType = 'exe'
   file = $unexe
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs
Remove-Item (Split-Path $unexe) -Recurse -Force

# remove the environment variable
Install-ChocolateyEnvironmentVariable 'ORTEP3DIR' $null 'Machine'
