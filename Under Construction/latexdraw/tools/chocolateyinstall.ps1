$ErrorActionPreference = 'Stop'; # stop on all errors

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$PackageDir = Split-Path -Parent $ToolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageDir -filter "LaTeXDraw*" | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$installArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = $PackageDir
}

Get-ChocolateyUnzip @installArgs

$target = (Get-ChildItem $PackageDir -filter "latexdraw.jar" -Recurse).fullname
$JavaPath = gwmi win32_product | ? {$_.name -match 'java'} | select installlocation

$ShortcutArgs = @{
   ShorcutFilePath = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'
   TargetPath = $JavaPath
   Arguments = "-xmx512m -jar `"$Target`""
   IconLocation = Join-Path $PackageDir 'tools\latexdraw.ico'
}

Install-ChocolateyShortcut @ShortcutArgs