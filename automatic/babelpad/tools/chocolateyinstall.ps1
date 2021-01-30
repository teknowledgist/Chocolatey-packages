$ErrorActionPreference = 'Stop'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "*.exe" 
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$ZipArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   url           = 'https://www.babelstone.co.uk/Software/Download/BabelPad.zip'
   checksum      = 'cb0a39f24c7618dcf481f7d27dea7029e9cd06f59c0c0b6da200baec25b91b6d'
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
