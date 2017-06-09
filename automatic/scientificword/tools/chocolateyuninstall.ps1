$packageName = 'ScientificWord'

$StartMenu = Join-Path $env:ALLUSERSPROFILE 'microsoft\windows\start menu\programs'
$Shortcut = Get-ChildItem -Path $StartMenu -Filter 'Uninstall sw *.lnk' -Recurse

$sh = New-Object -ComObject WScript.Shell
$Target = $sh.CreateShortcut($Shortcut.FullName).TargetPath

$UninstallArgs = @{
   Statements      = '--mode unattended --unattendedmodeui none'
   ExeToRun        = $Target
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
