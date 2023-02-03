$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem $toolsDir -filter '*.zip' |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty fullname -Last 1

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

Remove-Item $ZipFile -Force 

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\Text-Grab.lnk'
   TargetPath       = (Get-ChildItem $UnZipArgs.Destination -filter *.exe -Recurse).fullname
}
Install-ChocolateyShortcut @ShortcutArgs
