$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'wingx'} |
                     Select-Object -ExpandProperty UninstallString

$UninstallArgs = @{
   packageName = 'wingx'
   fileType = 'exe'
   file = $unexe
   silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
   validExitCodes = @(0)
}

Uninstall-ChocolateyPackage @UninstallArgs

# remove the environment variable
Install-ChocolateyEnvironmentVariable 'WINGXDIR' $null 'Machine'
Install-ChocolateyEnvironmentVariable 'PGFONT' $null 'Machine'
