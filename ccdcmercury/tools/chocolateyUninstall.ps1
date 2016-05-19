$packageName = 'ccdcmercury'

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'Mercury'} |
                     Select-Object -ExpandProperty UninstallString


if (Test-Path $unexe) {
  $UninstallArgs = @{
     packageName = $packageName
     fileType = 'exe'
     file = $unexe
     silentArgs = '--mode unattended'
     validExitCodes = @(0)
  }
  Uninstall-ChocolateyPackage @UninstallArgs
  Remove-Item (Split-Path $unexe) -Recurse -Force
} else {
  Throw "$packageName uninstaller not found!"
}



