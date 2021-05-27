$ErrorActionPreference = 'Stop' 

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'exe'
   url           = 'https://go.microsoft.com/fwlink/?linkid=860984'
   checksum      = '958f719fe7aa15f5c2f4b63ea9c3e6003df85783ca02c6eb079a34882fa8d0ba'
   checksumType  = 'sha256'
   silentArgs    = '/allusers /silent'
   validExitCodes= @(0)
}

$osInfo = Get-WmiObject Win32_OperatingSystem | Select-Object Version, ProductType, Caption, BuildNumber
Write-Verbose "Detected:  $($osInfo.Caption)"
If (([version]$osInfo.Version).Major -ne 10) {
   Write-Warning "OneDrive is not supported on $($osInfo.Caption)."
   Write-Host "To try installing OneDrive manually, use this URL to download the current version:`n" -ForegroundColor Cyan 
   Write-Host "   $($packageArgs.url)" -ForegroundColor Green
   Throw "This package cannot install OneDrive onto $($osInfo.Caption)."
}

Install-ChocolateyPackage @packageArgs 

<# This is a machine-wide install.  At least some versions of 
   the installer do not remove the per-user install command
   to run the Win10 "built-in" OneDrive installer.
   What follows should prevent that redundant action.
   Reference:  https://byteben.com/bb/installing-the-onedrive-sync-client-in-per-machine-mode-during-your-task-sequence-for-a-lightening-fast-first-logon-experience/
#> 
$RegPath = "$env:windir\system32\reg.exe"
$DefUReg = "$env:SystemDrive\Users\Default\NTUSER.DAT"
$TempKey = 'HKLM\DefaultUser'

try { 
   [IO.File]::OpenWrite($DefUReg).close()
   $unlocked = $true
   Write-Debug 'Default user registry key is available.'
} catch {
   $unlocked = $false
   Write-Debug 'Default user registry key is in use.  Attempting to release.'
   # unsure if this will work.  Pulled from:  https://osd365.com/windows-10-sporadic-user-profile-corruption-default-ntuser-dat-locked-by-system/
   Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements 'UNLOAD HKU\DefaultUserTemplate'
}

try {
   $null = Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements "LOAD $TempKey $DefUReg"

   $KeyPath = ([regex]'\\').replace($TempKey,':\',1) + '\Software\Microsoft\Windows\CurrentVersion\Run'

   $ODrunValue = (Get-ItemProperty -Path $KeyPath).OneDriveSetup
   if ($ODrunValue) {
      Remove-ItemProperty -Path $KeyPath -Name 'OneDriveSetup' -Force
      $BackedUpKey = "The default user registry file was loaded and the value`r`n`r`n" +
                     "OneDriveSetup = $ODrunValue`r`n`r`n" +
                     "was removed from \Software\Microsoft\Windows\CurrentVersion\Run`r`n" +
                     "Do not alter this file or the key  will not be restored on`r`n" +
                     'uninstallation of this package.'
      $BackedUpKey | out-file -FilePath "$env:ChocolateyPackageFolder\RemovedKeyInfo.txt" -Force
      Write-Verbose 'Registry key information for default user install of OneDrive is backed up.'
   }
   $null = Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements 'UNLOAD HKLM\DefaultUser'
   [gc]::collect()   # remove any memory handles to the file.
} catch {
   $note = "Removal of default per-user install of OneDrive failed.`n" +
            "This should not affect OneDrive function but could slow`n" +
            'down the login of new users.'
   Write-Warning $note
}

