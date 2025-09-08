﻿$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = 'TrayToolbar-win-x64-portable-1.5.5.zip'

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = Join-Path $toolsDir $ZipFile
   Destination    = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

Remove-Item (Join-Path $toolsDir $ZipFile) -Force 

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\TrayToolbar.lnk'
   TargetPath       = (Get-ChildItem $UnZipArgs.Destination -filter *.exe -Recurse).fullname
}
Install-ChocolateyShortcut @ShortcutArgs
