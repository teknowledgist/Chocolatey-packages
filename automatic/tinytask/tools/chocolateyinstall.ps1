$ErrorActionPreference = 'Stop'

$FolderOfPackage = Split-Path -Parent "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$ZipArgs = @{
   packageName   = $env:ChocolateyPackageName
   unzipLocation = Join-Path $FolderOfPackage "$($env:ChocolateyPackageName)_$($env:ChocolateyPackageVersion)"
   url           = 'https://github.com/frankwick/t/raw/main/tinytask.zip'
   checksum      = '55CCDB4FBF69A4466AAF5B800ABEDBA37BB76FD1D50577335C0AE1D88EB19BBC'
   checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @ZipArgs

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter *.exe).fullname
$null = New-Item "$GUI.gui" -Type file -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms 'TinyTask.lnk'
   TargetPath = $GUI
}

Install-ChocolateyShortcut @ShortcutArgs
