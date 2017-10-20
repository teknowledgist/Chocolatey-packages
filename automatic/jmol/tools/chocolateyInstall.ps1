$ErrorActionPreference = 'Stop'; # stop on all errors

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$PackageDir = Split-Path -Parent $ToolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageDir -filter "jmol*" | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$installArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = $PackageDir
}

Get-ChocolateyUnzip @installArgs

$JavaExe = "$env:ProgramData\Oracle\Java\javapath\javaw.exe"
$target = (Get-ChildItem $PackageDir -filter jmol.jar -Recurse).fullname
$icon = Join-Path $PackageDir 'tools\Jmol_icon13.ico'
$launcher = Join-Path $PackageDir 'Jmol Launcher.exe'
$SGpath = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $SGpath -o $launcher -p $JavaExe -c "-jar '$target'" -i $icon --gui

$shortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) 'Jmol.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $launcher -IconLocation $icon
