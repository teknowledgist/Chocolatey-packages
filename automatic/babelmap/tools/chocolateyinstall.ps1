$ErrorActionPreference = 'Stop'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "*.exe" 
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$ZipArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Split-path (Split-path $MyInvocation.MyCommand.Definition)
   url           = 'https://www.babelstone.co.uk/Software/Download/BabelMap.zip'
   checksum      = 'f962aa429e9bcb5f25f19240b229284fb1224e439024ee13e04f7b966310a0f1'
   checksumType  = 'sha256' 
}

Install-ChocolateyZipPackage @ZipArgs

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter *.exe).fullname
$null = New-Item "$GUI.gui" -Type file -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms "BabelMap.lnk"
   TargetPath = $GUI
}

Install-ChocolateyShortcut @ShortcutArgs
