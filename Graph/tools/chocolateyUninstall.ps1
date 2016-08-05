$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = (Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'Graph' -and $_.publisher -eq 'Ivan Johansen'} |
                     Select-Object -ExpandProperty UninstallString).trim('"')

if (test-path $unexe) {
   $UninstallArgs = @{
      packageName = 'graph'
      fileType = 'exe'
      file = $unexe
      silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
      validExitCodes = @(0)
   }

   Uninstall-ChocolateyPackage @UninstallArgs
} else {
   throw 'Uninstaller not found!'
}