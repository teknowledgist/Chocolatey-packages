$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

$target = Get-ChildItem $ToolsDir -filter *.jar |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

# Need to find where 'javaw.exe' is installed
$key = Get-UninstallRegistryKey -SoftwareName "*Temurin JRE*" | 
         Where-Object {$_.DisplayVersion -match '^11'} | 
         Sort-Object InstallDate | Select-Object -Last 1
$JavaW = (Get-ChildItem $key.InstallLocation -Filter 'javaw.exe' -Recurse).FullName

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'Master Password.lnk'
   TargetPath = $JavaW
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $ToolsDir 'MasterPassword.ico'
}

Install-ChocolateyShortcut @ShortcutArgs