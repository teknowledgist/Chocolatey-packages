$ErrorActionPreference = 'Stop'

$SoftwareName = 'Microsoft Visual Studio 2010 Tools for Office Runtime*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 0) {
   Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} elseif ($key.Count -le 2) {
   # VSTOR install usually creates two uninstall keys.  Either does the job fully,
   #    but only one is silent for Chocolatey's Automatic Uninstaller
   $uninstallString = $key[0].UninstallString
   if ($uninstallString -like 'MsiExec*') {
      $packageArgs = @{
         packageName   = $env:ChocolateyPackageName
         softwareName  = $SoftwareName
         file          = $uninstallString
         fileType      = 'MSI'
         silentArgs    = "/qn /norestart"
         validExitCodes= @(0, 3010, 1605, 1614, 1641) # https://msdn.microsoft.com/en-us/library/aa376931(v=vs.85).aspx
      }
   } else {
      $packageArgs = @{
         packageName   = $env:ChocolateyPackageName
         softwareName  = $SoftwareName
         file          = $uninstallString
         fileType      = 'EXE'
         silentArgs    =  '/uninstall /quiet /norestart'
         validExitCodes= @(0)
      }
   } 
   Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -gt 2) {
   Write-Warning "$($key.Count) matches found!"
   Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
   Write-Warning "Please alert package maintainer the following keys were matched:"
   $key | % {Write-Warning "- $($_.DisplayName)"}
}


