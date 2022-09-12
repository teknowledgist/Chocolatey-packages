$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "LaTeXDraw*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$unzipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = $FolderOfPackage
}
Get-ChocolateyUnzip @unzipArgs

$JReg = 'HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment'
$JVer=(Get-ItemProperty $JReg).CurrentVersion
$JavaHome = (Get-ItemProperty $JReg/$JVer).JavaHome
$JavaPath = (Get-ChildItem $JavaHome -Filter "javaw.exe" -Recurse).fullname

$Target = (Get-ChildItem $FolderOfPackage -filter "latexdraw.jar" -Recurse).fullname

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'LaTeXDraw.lnk'
   TargetPath = $JavaPath
   Arguments = "-jar `"$Target`""
   IconLocation = Join-Path $FolderOfPackage 'tools\latexdraw.ico'
}

Install-ChocolateyShortcut @ShortcutArgs