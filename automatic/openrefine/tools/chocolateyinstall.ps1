﻿$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter 'openrefine*' | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://github.com/OpenRefine/OpenRefine/releases/download/3.9.5/openrefine-win-with-java-3.9.5.zip'
   Checksum     = '8b19cc383e553692ad7f6db8aff8ed3f5c6d8c8be6654b5521233796ba4ef559'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}
$ZipFile = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = $FolderOfPackage
}
Get-ChocolateyUnzip @UnzipArgs

$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcut = Join-Path $StartMenu 'OpenRefine.lnk'
$Target = get-childitem $FolderOfPackage -Filter openrefine.exe -recurse

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $Target.FullName -WorkingDirectory $Target.DirectoryName

$files = get-childitem $FolderOfPackage -Filter *.exe -Exclude openrefine* -Recurse 
foreach ($file in $files) {
  #generate an ignore file
  $null = New-Item "$file.ignore" -type file -force
}
