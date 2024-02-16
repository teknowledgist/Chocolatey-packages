$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$FolderOfPackage = Split-Path -Parent $toolsDir
$fileLocation = (Get-ChildItem -Path $toolsDir -filter '*.zip' |
                        Sort-Object lastwritetime | Select-Object -Last 1).FullName

$UnZipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $fileLocation
   Destination    = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_v$env:ChocolateyPackageVersion"
}
Get-ChocolateyUnzip @UnZipArgs

$bits = Get-OSArchitectureWidth

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs\SIV.lnk'
   TargetPath       = (Get-ChildItem $UnZipArgs.Destination -Filter "*$($bits)X.exe").FullName
}
Install-ChocolateyShortcut @ShortcutArgs
   
Remove-Item $fileLocation

Get-ChildItem -Path $UnZipArgs.Destination -filter *.exe -Recurse | ForEach-Object {
      $null = New-Item $($_.FullName + '.ignore') -Force -ItemType file
}
