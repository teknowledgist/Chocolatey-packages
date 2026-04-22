$ErrorActionPreference = 'Stop'
  
$InstallArgs = @{
   packageName   = $env:ChocolateyPackageName
   softwareName  = 'Anaconda3'
   fileType      = 'EXE'
   url64bit      = 'https://repo.anaconda.com/archive/Anaconda3-2025.12-1-Windows-x86_64.exe'
   checksum64    = '09c8a69e7a717a963a9f251697473f4ea887878696c3ec4e7e454f5eabb75afe'
   checksumType  = 'sha256'
   validExitCodes= @(0)
}

$pp = Get-PackageParameters

$ToolsDir = Get-ToolsLocation
if (test-path "$ToolsDir\Anaconda3\condabin\conda") {
   # Anaconda is/was installed already. Have it update itself, or start fresh?
   if ($pp['Fresh']) {
      # If starting fresh, need to uninstall (possibly non-Chocolatey installed)
      [array]$key = Get-UninstallRegistryKey -SoftwareName 'Anaconda3*'

      if ($key.Count -eq 1) {
         $UninstallArgs = @{
            ExeToRun       = $key[0].UninstallString
            Statements     = $Switches
            ValidExitCodes = @(0)
         }
         $null = Start-ChocolateyProcessAsAdmin @UninstallArgs
         # The uninstaller starts another process and immediately returns.  
         Write-Warning "Uninstalling Anaconda v$($key[0].DisplayVersion) in preparation for a requested 'Fresh' install."
         Get-Process | Where-Object { $_.path -match '\\Un\.exe' } | wait-process
      }
      elseif ($key.Count -eq 0) {
         Write-Warning "Anaconda is not installed, but installation/config files remain in $ToolsDir.\r\n   Reinstallation will be attempted."
      }
      elseif ($key.Count -gt 1) {
         Write-Warning "$($key.Count) matches found!"
         Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
         Throw "A 'Fresh' install is not possible with multiple existing installs."
      }
   } else {
      
   }


}


}
# c:\tools\Anaconda3\condabin\conda update --all -y
# 

if (!$pp['JustMe']) { $T = 'AllUsers' } 
else { 
   Write-Host 'You have opted to install for the current user only.' -ForegroundColor Cyan
   $T = 'JustMe'
}

if (!$pp['DoNotRegister']) { $R = '1' } 
else { 
   Write-Host 'You have opted to NOT register this installation of Python.' -ForegroundColor Cyan
   $R = '0'
}

if (!$pp['AddToPath']) { $P = '0' } 
else { 
   Write-Host 'You have opted to add Anaconda Python to the path.' -ForegroundColor Cyan
   if ($T -eq 'AllUsers') {
      Write-Warning 'Adding to the path is disabled for AllUser installs as of the 2022.05 release!'
   }
   $P = '1'
}

if (!$pp['D']) {
    $D = Join-Path $ToolsDir 'Anaconda3'
} else {
    if (!(Test-Path $pp['D'])) {
        Write-Error "`nThe destination ('/D') parameter, '$($pp['D'])' is not an available path!"
    } else {
       Write-Host "You wish to install to the path: $($pp['D'])" -ForegroundColor Cyan
       $D = Join-Path $pp['D'] 'Anaconda3'
    }
}
  
$InstallArgs.add('silentArgs',"/S /InstallationType=$T /RegisterPython=$R /AddToPath=$P /D=$D")

Write-Warning 'The Anaconda3 installation can take a long time (up to 30 minutes).'
Write-Warning 'Please be patient and let it finish.'
Write-Warning 'If you want to verify the install is running, you can watch the installer process in Task Manager'

Install-ChocolateyPackage @InstallArgs
