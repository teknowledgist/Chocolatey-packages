$ErrorActionPreference = 'Stop'  # stop on all errors

$url      = 'http://lastools.org/download/LAStools.zip'
$CheckSum = 'fca1fd69cb60a3009d31359c3f40cff60622b4e76a1cbe1bbef3aca353d2546b'

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
