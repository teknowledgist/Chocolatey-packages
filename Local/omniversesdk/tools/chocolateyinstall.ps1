$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove old versions
$Previous = Get-ChildItem $FolderOfPackage -Filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$pp = Get-PackageParameters

if (!$pp['ZipPath']) { 
   Throw 'Omniverse Kit SDK zip file location not provided!'
} else { 
   if (Test-Path $pp['ZipPath'] -PathType Leaf) {
      $ZipFile = $pp['ZipPath']
   } else {
      $ZipFile = Get-ChildItem -Path $pp['ZipPath'] -filter '*.zip' |
                  Sort-Object lastwritetime | Select-Object -Last 1 -ExpandProperty FullName
      Write-Host "ZipFile '$ZipFile' will be used." -ForegroundColor Cyan
   }
}

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}

Get-ChocolateyUnzip @UnzipArgs

$EXE = Get-ChildItem $UnzipArgs.Destination -filter 'kit.exe' -recurse

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'Omniverse Kit SDK.lnk'
   TargetPath       = $EXE.FullName
   Arguments        = Join-Path (Split-Path $EXE.DirectoryName) 'apps\omni.app.editor.base.kit'
}
Install-ChocolateyShortcut @ShortcutArgs

