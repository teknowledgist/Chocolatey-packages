$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

$target = Get-ChildItem $ToolsDir -filter *.jar |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

# If the Java dependency was just installed, the environment
#   must be updated to access the 'JAVA_HOME' variable
Update-SessionEnvironment
$JavaPath = (Get-ChildItem $env:Java_Home -Filter 'javaw.exe' -Recurse).fullname

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'Master Password.lnk'
   TargetPath = $JavaPath
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $ToolsDir 'MasterPassword.ico'
}

Install-ChocolateyShortcut @ShortcutArgs