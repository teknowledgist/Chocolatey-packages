$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | 
               Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = (Get-ChildItem $toolsDir *.zip).fullname
$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile
   Destination    = $FolderOfPackage
}
Get-ChocolateyUnzip @UnZipArgs

Remove-Item $ZipFile -Force 

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\Edit.lnk'
   TargetPath       = (Get-ChildItem $FolderOfPackage -filter edit.exe -Recurse).fullname
}
Install-ChocolateyShortcut @ShortcutArgs
