$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'ILLiad Client*'
  fileType      = 'EXE'
  silentArgs   = ''
  validExitCodes= @(0)
}

[array]$Keys = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($Keys.Count -gt 2) {
   Throw 'More than one install of  found!  Cannot uninstall without risking other copies.'
} elseif ($Keys.Count -eq 2) {
   Write-Verbose 'Found an InstallShield install of ILLiad.'
   $TargetKey = $Keys | Where-Object {$_.UninstallString -notmatch 'msiexec'}
   $packageArgs['file'] = $TargetKey.UninstallString.split('"')[1]
   $ProductCode = $packageArgs['file'] -replace '.*(\{[0-9a-f-]+\}).*','$1'

   # InstallShield requires an answer file
   $AnswerText = @"
[$($ProductCode)-DlgOrder]
Dlg0=$($ProductCode)-SprintfBox-0
Count=2
Dlg1=$($ProductCode)-SdFinish-0
[$($ProductCode)-SprintfBox-0]
Result=1
[$($ProductCode)-SdFinish-0]
Result=1
bOpt1=0
bOpt2=0
"@
   $AnswerText | Out-File "$env:Temp\Answers.iss" -Force

   $Args = $TargetKey.UninstallString.split('"')[-1].trim()

   $packageArgs['silentArgs'] = $Args -replace '-removeonly',"-uninst /s /f1$env:Temp\Answers.iss"
   Uninstall-ChocolateyPackage @packageArgs

} elseif ($Keys.Count -eq 1) {
    $packageArgs['file'] = "$Keys[0].UninstallString)"
    Uninstall-ChocolateyPackage @packageArgs
} elseif ($Keys.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
}
