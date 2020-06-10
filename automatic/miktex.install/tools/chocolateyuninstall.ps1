$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$MiKTeXsetup = Get-ChildItem $toolsDir 'miktexsetup.exe' | Select-Object -ExpandProperty FullName

# Is MiKTeX already installed?
[array]$key = Get-UninstallRegistryKey -SoftwareName 'miktex*' 
if ($key.Count -gt 1) {
   Throw 'More than one install of MiKTeX found!  Cannot uninstall without risking other copies.'
} elseif ($key.Count -eq 1) {
   Write-Verbose 'Uninstalling MiKTeX using setup utility.'
   $InstallArgs = @{
      Statements       = '--verbose --shared uninstall'
      ExetoRun         = $MiKTeXsetup
      WorkingDirectory = $toolsDir
      validExitCodes   = @(0)
   }
   $exitCode = Start-ChocolateyProcessAsAdmin @InstallArgs
}

