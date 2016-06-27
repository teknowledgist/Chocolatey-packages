$packageName = 'fossamail'

$RegistryLocation = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall'

# different key for 32-bit installs on 64-bit systems
$BitLevel = Get-ProcessorBits
If ($BitLevel -eq '64') {
   $RegistryLocation = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
}

$unexe = Get-ItemProperty "$RegistryLocation\*" | 
                     Where-Object { $_.displayname -match 'FossaMail'} |
                     Select-Object -ExpandProperty UninstallString

if ([string]::IsNullOrEmpty($unexe)) {
	Throw "$packageName is not installed!"
} elseif (Test-Path -Path $unexe) {
  $UninstallArgs = @{
     packageName = $packageName
     fileType = 'exe'
     file = $unexe
     silentArgs = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
     validExitCodes = @(0)
  }
  Uninstall-ChocolateyPackage @UninstallArgs
} else {
  Throw "$packageName uninstaller not found!"
}
