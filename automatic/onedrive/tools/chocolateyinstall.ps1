$ErrorActionPreference = 'Stop' 

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'exe'
   url           = 'https://go.microsoft.com/fwlink/?linkid=844652'
   checksum      = 'ed29bc59caa58162b135ff0d970df5651cb5802e3aef5fc02f7f8bedf9ca11b8'
   checksumType  = 'sha256'
   silentArgs    = '/allusers /silent'
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs 

<# This is a machine-wide install.  At least some versions of 
   the installer do not remove the per-user install command
   to run the Win10 "built-in" OneDrive installer.
   What follows should prevent that redundant action.
   Reference:  https://byteben.com/bb/installing-the-onedrive-sync-client-in-per-machine-mode-during-your-task-sequence-for-a-lightening-fast-first-logon-experience/
#> 

try {
   $RegPath = "$env:windir\system32\reg.exe"
   $KeyPath = 'HKLM:\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Run'

   $null = Start-ChocolateyProcessAsAdmin -ExeToRun $RegPath -Statements "LOAD HKLM\DefaultUser `"$env:SystemDrive\Users\Default\NTUSER.DAT`""

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
} catch {
   $note = "Removal of default per-user install of OneDrive failed.`n" +
            "This should not affect OneDrive function but could slow`n" +
            'down the login of new users.'
   Write-Warning $note
}

