$ErrorActionPreference = 'Stop'  # stop on all errors

$url      = 'http://lastools.org/download/LAStools.zip'
$CheckSum = 'c7a559db0f58528f6bdd685a6a6c94244ed36bf2d75140f975d731b6384efee4'

$ZipArgs = @{
   PackageName   = 'lastools'
   Url           = $url
   Checksum      = $CheckSum
   ChecksumType  = 'sha256'
   UnzipLocation = Split-Path (Split-Path -parent $MyInvocation.MyCommand.Definition)
}

Install-ChocolateyZipPackage @ZipArgs

$exes = Get-ChildItem $ZipArgs.UnzipLocation -filter *.exe -Recurse |select -ExpandProperty fullname
$txts = Get-ChildItem $ZipArgs.UnzipLocation -filter *.txt -Recurse |select -ExpandProperty fullname

foreach ($exe in $exes) {
   if ($txts -notcontains ($exe.trim('.exe') + '_README.txt')) {
      New-Item "$exe.ignore" -Type file -Force | Out-Null
   }
}

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter lastool.exe -Recurse).fullname
New-Item "$GUI.gui" -Type file -Force | Out-Null

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'LASTool.lnk'
   TargetPath = $GUI
}

Install-ChocolateyShortcut @ShortcutArgs
