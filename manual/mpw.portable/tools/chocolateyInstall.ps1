$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

$target = (Get-ChildItem $ToolsDir -filter *.jar -Recurse).fullname

$JReg = 'HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment'
$JVer=(Get-ItemProperty $JReg).CurrentVersion
$JavaHome = (Get-ItemProperty $JReg/$JVer).JavaHome
$JavaPath = (Get-ChildItem $JavaHome -Filter 'javaw.exe' -Recurse).fullname

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'Master Password.lnk'
   TargetPath = $JavaPath
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $ToolsDir 'MasterPassword.ico'
}

Install-ChocolateyShortcut @ShortcutArgs