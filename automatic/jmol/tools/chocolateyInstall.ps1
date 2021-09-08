$ErrorActionPreference = 'Stop'; # stop on all errors

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$PackageDir = Split-Path -Parent $ToolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageDir -filter "jmol*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$installArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = $PackageDir
}

Get-ChocolateyUnzip @installArgs

$target = (Get-ChildItem $PackageDir -filter jmol.jar -Recurse).fullname

# If the Java dependency was just installed, the environment
#   must be updated to access the 'JAVA_HOME' variable
Update-SessionEnvironment
$JavaPath = (Get-ChildItem $env:Java_Home -Filter 'javaw.exe' -Recurse).fullname

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'
   TargetPath = $JavaPath
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $PackageDir 'tools\Jmol_icon13.ico'
}

Install-ChocolateyShortcut @ShortcutArgs