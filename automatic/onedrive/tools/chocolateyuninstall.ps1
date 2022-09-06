$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Restore the per-user install of the built-in OneDrive (if it was there)
if (Test-Path "$PackageFolder\RemovedKeyInfo.txt") {
   $RegPath = "$env:windir\system32\reg.exe"
   $KeyPath = 'HKLM:\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Run'

   $null = Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements "LOAD HKLM\DefaultUser `"$env:SystemDrive\Users\Default\NTUSER.DAT`""

   $RegKey = (Get-Content "$PackageFolder\RemovedKeyInfo.txt" | 
                  Where-Object {$_ -match '='}).split('=').trim()
   Set-ItemProperty -Path $KeyPath -Name $RegKey[0] -Value $RegKey[1] -Force

   $null = Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements 'UNLOAD HKLM\DefaultUser'
   [gc]::collect()    # remove any memory handles to the file.
   Write-Verbose 'Previous registry key restored.'
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft OneDrive*'
  fileType      = 'EXE'
  silentArgs    = '/uninstall /allusers'
  validExitCodes= @(0)
}

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object { 
    $packageArgs['file'] = "$($_.UninstallString.split('/')[0])"
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning 'To prevent accidental data loss, no programs will be uninstalled.'
  Write-Warning 'Please alert package maintainer the following keys were matched:'
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}


