$ErrorActionPreference = 'Stop'

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   FileType       = 'exe'
   Url            = 'https://crystalexplorer.sfo2.cdn.digitaloceanspaces.com/downloads/CrystalExplorer-17.5-win32.exe'
   checkSum       = 'c825468851224a1a3a64539dec493cff974f2761dba8edd18b211d30acdde33e'
   checkSumType   = 'sha256'
   silentArgs     = '/S' 
   validExitCodes = @(0)
}
Install-ChocolateyPackage @InstallArgs

if (${Env:ProgramFiles(x86)}) { $DestDir = ${Env:ProgramFiles(x86)} }
else { $DestDir = $Env:ProgramFiles }

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms "$env:ChocolateyPackageName.lnk"
   TargetPath       = (Get-ChildItem (join-path $DestDir "$env:ChocolateyPackageName*") -include 'cry*.exe' -Recurse).fullname
   IconLocation     = Join-Path (Split-Path -parent $script:MyInvocation.MyCommand.Path) 'CrystalExplorer.ico'
}
Install-ChocolateyShortcut @ShortcutArgs
