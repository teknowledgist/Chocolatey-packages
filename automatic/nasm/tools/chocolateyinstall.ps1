$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$Files = Get-ChildItem $toolsDir -Filter '*.exe' |
               Sort-Object LastWriteTime | 
               Select-Object -Last 2

$File32 = ($Files | Where-Object {$_.Name -match 'x86\.exe'}).fullname
$File64 = ($Files | Where-Object {$_.Name -match 'x64\.exe'}).fullname

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
   Remove-Item $File.fullname -ea 0 -force
}

# The NASM installer includes the version in the Start Menu folder, but
#   doesn't change the number on updates.  Removing the number is simplest.
$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu'
$SMfolder = Get-ChildItem $StartMenu -Filter "Netwide Assembler*" -Recurse -Directory
$null = Rename-Item $SMfolder.FullName ($SMfolder.FullName -replace '[0-9.]','').trim() -Force

