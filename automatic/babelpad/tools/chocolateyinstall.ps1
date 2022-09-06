$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageFolder -filter "*.exe" 
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$ZipArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   url           = 'https://www.babelstone.co.uk/Software/Download/BabelPad.zip'
   checksum      = '7aa90dd277c5c98ad2f162c884fce10c4ae503e1790126ebe75fc1f22f508fc4'
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
