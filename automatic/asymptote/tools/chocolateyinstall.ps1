$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$File = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 1

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File64         = $File.Fullname
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @packageArgs

Remove-Item $File.fullname -ea 0 -force

Write-Debug 'Moving Start Menu shortcuts from user to all users.'
$UserSM = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"
$AllUSM = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\"
Copy-Item -Path "$($UserSM)Asymptote" -Destination $AllUSM -Recurse -Force
Remove-Item -Path "$($UserSM)Asymptote" -Recurse

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']
if ($key.Count -eq 1) {
   Install-ChocolateyPath -PathToInstall (Split-Path $key[0].DisplayIcon) -PathType 'Machine'
} 

