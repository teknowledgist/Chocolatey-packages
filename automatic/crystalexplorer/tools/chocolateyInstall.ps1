$ErrorActionPreference = 'Stop'  # stop on all errors

$packageName = 'CrystalExplorer'

$url      = 'http://crystalexplorer.scb.uwa.edu.au/downloads/CrystalExplorer-17.5-win32.exe'
$version  = '17.5'
$Checksum = 'c825468851224a1a3a64539dec493cff974f2761dba8edd18b211d30acdde33e'

if (${Env:ProgramFiles(x86)}) { $DestDir = ${Env:ProgramFiles(x86)} }
else { $DestDir = $Env:ProgramFiles }

$InstallArgs = @{
   PackageName    = $packageName
   FileType       = 'exe'
   Url            = $url
   checkSum       = $Checksum
   checkSumType   = 'sha256'
   silentArgs     = '/S' 
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath("Desktop")) "$packageName.lnk"
   TargetPath       = (Get-ChildItem (join-path $DestDir "$packageName*") -include 'cry*.exe' -Recurse).fullname
   Icon             = Join-Path (Split-Path -parent $script:MyInvocation.MyCommand.Path) 'CrystalExplorer.ico'
}
Install-ChocolateyShortcut @ShortcutArgs
