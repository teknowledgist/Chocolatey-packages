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

$JReg = 'HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment'
$JVer=(Get-ItemProperty $JReg).CurrentVersion
$JavaHome = (Get-ItemProperty $JReg/$JVer).JavaHome
$JavaPath = (Get-ChildItem $JavaHome -Filter "javaw.exe" -Recurse).fullname

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'
   TargetPath = $JavaPath
   Arguments = "-xmx512m -jar `"$Target`""
   IconLocation = Join-Path $PackageDir 'tools\Jmol_icon13.ico'
}

Install-ChocolateyShortcut @ShortcutArgs