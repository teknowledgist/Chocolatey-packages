$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$File32 = ($Files | Where-Object {$_.Name -match '32\.exe'}).fullname
$File64 = ($Files | Where-Object {$_.Name -notmatch '32\.exe'}).fullname

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   File           = $File32
   File64         = $File64
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

foreach ($File in $Files) {
   Remove-Item $File -ea 0 -force
}

Write-Debug 'Moving Start Menu shortcuts from user to all users.'
$UserSM = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\"
$AllUSM = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\"
Copy-Item -Path "$($UserSM)Asymptote" -Destination $AllUSM -Recurse -Force
Remove-Item -Path "$($UserSM)Asymptote" -Recurse

