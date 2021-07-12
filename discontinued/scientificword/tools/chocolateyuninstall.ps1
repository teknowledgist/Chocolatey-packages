$packageName = 'ScientificWord'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'Scientific Word'

$UninstallArgs = @{
   Statements      = '--mode unattended --unattendedmodeui none'
   ExeToRun        = $key.UninstallString
   validExitCodes = @(0)
}
Start-ChocolateyProcessAsAdmin @UninstallArgs

if ($env:mackichn_LICENSE) {
   Uninstall-ChocolateyEnvironmentVariable -VariableName 'mackichn_LICENSE' -VariableType 'Machine'
} else {
   $TrialLicense = join-path ([System.Environment]::GetFolderPath('Desktop')) 'Scientific Word Trial Serial Number.txt'
   if (test-path $TrialLicense) {
      Remove-Item $TrialLicense
   }
}
