$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove old versions
$Previous = Get-ChildItem $FolderOfPackage -Filter "$env:ChocolateyPackageName*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$ZipFile = Get-ChildItem -Path $toolsDir -filter '*.zip' |
                  Sort-Object lastwritetime | Select-Object -Last 1 -ExpandProperty FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $FolderOfPackage

$EXEs = Get-ChildItem $FolderOfPackage -filter *.exe -recurse

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

ForEach ($bin in $EXEs) {
   if ($bin.name -notmatch $env:ChocolateyPackageName) {
      $null = New-Item "$($bin.fullname).ignore" -Force
   } else {
      $ShortcutArgs = @{
         ShortcutFilePath = Join-Path $StartPrograms "Sioyek.lnk"
         TargetPath = $bin.fullname
      }
      Install-ChocolateyShortcut @ShortcutArgs
   }
}

