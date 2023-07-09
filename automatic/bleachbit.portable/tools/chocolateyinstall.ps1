$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter 'BleachBit*' | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile   = Get-ChildItem -Path $toolsDir -Filter '*.zip' | Sort-Object LastWriteTime | Select-Object -Last 1

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $ZipFile.FullName
   Destination    = $FolderOfPackage
}
Get-ChocolateyUnzip @UnZipArgs
Remove-Item $ZipFile.fullname -Force 

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'BleachBit.lnk'
   TargetPath       = (Get-ChildItem $FolderOfPackage -filter "bleachbit.exe" -Recurse).FullName
   RunAsAdmin       = $true
}
Install-ChocolateyShortcut @ShortcutArgs

$files = Get-ChildItem $FolderOfPackage -Filter *.exe -Exclude bleachbit* -Recurse 
foreach ($file in $files) {
  #generate an ignore file
  $null = New-Item "$file.ignore" -type file -force
}
