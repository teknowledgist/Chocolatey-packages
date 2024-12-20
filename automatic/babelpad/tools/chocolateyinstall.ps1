$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "*.exe" 
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$ZipArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   url           = 'https://www.babelstone.co.uk/Software/Download/BabelPad.zip'
   checksum      = 'eed79df5a1e4638cb9006ec807fc47f16c5966f95ea319075336b819f40285b0'
   checksumType  = 'sha256' 
}

Install-ChocolateyZipPackage @ZipArgs

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter *.exe).fullname
$null = New-Item "$GUI.gui" -Type file -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms "BabelPad.lnk"
   TargetPath = $GUI
}

Install-ChocolateyShortcut @ShortcutArgs
