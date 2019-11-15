$ErrorActionPreference = 'Stop'  # stop on all errors

$url      = 'https://lastools.github.io/download/LAStools.zip'
$CheckSum = 'e0389f3488de2c67639f06934e882e1b2dc9096292bf5a2a0f25901f4fa664f9'

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
