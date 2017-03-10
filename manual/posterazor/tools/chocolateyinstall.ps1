$ErrorActionPreference = 'Stop'

$packageName= 'posterazor'
$url      = 'https://sourceforge.net/projects/posterazor/files/Binary%20Releases/1.5.2/PosteRazor-1.5.2-Win32.zip'
$CheckSum = '2A91A2445D34FF2B7791815924EFAB1AA0EDC55AC282BB03AAA48147C13277F6'

$ZipArgs = @{
   PackageName   = $packageName
   Url           = $url
   Checksum      = $CheckSum
   ChecksumType  = 'sha256'
   UnzipLocation = Split-Path (Split-Path -parent $MyInvocation.MyCommand.Definition)
}

Install-ChocolateyZipPackage @ZipArgs

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'PosteRazor.lnk'
   TargetPath       = Join-Path $ZipArgs.UnzipLocation 'PosteRazor.exe'
   IconLocation     = Join-Path $ZipArgs.UnzipLocation 'tools\PosteRazor.ico'
}

Install-ChocolateyShortcut @ShortcutArgs
