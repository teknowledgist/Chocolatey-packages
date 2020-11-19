$ErrorActionPreference = 'Stop'

# Is MiKTeX already installed?
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*' 
if ($key.Count -gt 1) {
   Throw 'More than one install of MiKTeX found!  Cannot uninstall without risking other copies.'
} elseif ($key.Count -eq 1) {
   Write-Verbose "Found an install of MiKTeX."
   # Use MiKTeX's built-in updater
   $InstallDir = (Split-Path $key.UninstallString).trim('"')
   $MiKTeXsetup = Join-Path $InstallDir 'miktexsetup.exe'
   Write-Verbose 'Uninstalling MiKTeX using integrated setup utility.'
   $InstallArgs = @{
      Statements       = '--verbose --shared=yes uninstall'
      ExetoRun         = $MiKTeXsetup
      WorkingDirectory = $InstallDir
      validExitCodes   = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @InstallArgs
   Write-Verbose "MiKTeX uninstall process exited with:  $exitCode"

   # Sometimes items are left behind
   if (Test-Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\MiKTeX") {
      Remove-Item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\MiKTeX" -Force -Recurse
   }
}

