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
   url           = 'https://www.babelstone.co.uk/Software/Download/BabelMap.zip'
   checksum      = 'cfaf28b9464b339e7322256c2541552b92170c39856e314056f8935f7c14f25d'
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
