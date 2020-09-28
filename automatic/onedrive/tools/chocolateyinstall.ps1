$ErrorActionPreference = 'Stop' 

$packageArgs = @{
   packageName   = $env:chocolateyPackageName
   fileType      = 'exe'
   url           = 'https://go.microsoft.com/fwlink/?linkid=844652'
   checksum      = 'ed29bc59caa58162b135ff0d970df5651cb5802e3aef5fc02f7f8bedf9ca11b8'
   checksumType  = 'sha256'
   silentArgs    = "/AllUsers"
   validExitCodes= @(0)
}

Install-ChocolateyPackage @packageArgs 

<# This is a machine-wide install.  At least some versions of 
   the installer do not remove the per-user install command
   to run the Win10 "built-in" OneDrive installer.
   What follows should prevent that (as it is redundant).
   Reference:  https://byteben.com/bb/installing-the-onedrive-sync-client-in-per-machine-mode-during-your-task-sequence-for-a-lightening-fast-first-logon-experience/
#> 

try {
   REG LOAD HKLM\DefaultUser "$env:SystemDrive\Users\Default\NTUSER.DAT"
   $RegPath = 'HKLM:\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Run'
   $ODrunValue = (Get-ItemProperty $RegPath).OneDriveSetup
   if ($ODrunValue) {
      Remove-ItemProperty -Path $RegPath -Name "OneDriveSetup" 
      $RegText = @"
Windows Registry Editor Version 5.00

; This key is not literal.  It was loaded from the default user registry file.
[HKEY_LOCAL_MACHINE\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Run]
"OneDriveSetup"="$ODrunValue"
"@
      $RegText.replace("`n","`r`n") | out-file "$env:ChocolateyPackageFolder\Removed.reg" -Force
   }
   REG UNLOAD HKLM\DefaultUser
} catch {
   $note = "Removal of default per-user install of OneDrive failed.`n" +
            "This should not affect OneDrive function but could slow`n" +
            "down the login of new users."
   Write-Warning $note
}

