$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$File32 = ($files | Where-Object {$_.Name -match "win32"}).fullname
$File64 = ($files | Where-Object {$_.Name -match "win64"}).fullname

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   softwareName = "$env:ChocolateyPackageName*"
   fileType     = 'EXE' 
   File         = ($files | Where-Object {$_.Name -match "win32"}).fullname
   File64       = ($files | Where-Object {$_.Name -match "win64"}).fullname
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @InstallArgs

foreach ($exe in $Files) {
   Remove-Item $exe.fullname -ea 0 -force
}
