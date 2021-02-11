$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -filter '*.exe' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE' 
   file           = "$fileLocation"
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/S'
   validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $fileLocation -ea 0 -force

# The installer places the Start Menu shortcut in the current user profile only
$UserStart = Join-Path $env:APPDATA '\Microsoft\Windows\Start Menu\Programs'
$OrigLNK = Get-ChildItem -Path $UserStart -Filter "$env:ChocolateyPackageName.lnk" -Recurse
# Creating a Start Menu shortcut for all users.
$AllStart = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$NewLNK = Copy-Item $OrigLNK.FullName $AllStart -Force -PassThru
$null = Remove-Item $OrigLNK.FullName

