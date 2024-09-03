$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

$target = Get-ChildItem $ToolsDir -filter *.jar |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

# If the Java dependency was just installed, the environment
#   must be updated to access the 'JAVA_HOME' variable
Update-SessionEnvironment
$ErrorActionPreference = 'silentlycontinue'
$JavaHome = (java -XshowSettings:properties -version 2>&1 | Where-Object {$_ -match 'java.home'}).tostring().split('=')[-1].trim()
$ErrorActionPreference = 'Stop'

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'Master Password.lnk'
   TargetPath = (Get-ChildItem $JavaHome -Filter 'javaw.exe' -Recurse).fullname
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $ToolsDir 'MasterPassword.ico'
}

Install-ChocolateyShortcut @ShortcutArgs