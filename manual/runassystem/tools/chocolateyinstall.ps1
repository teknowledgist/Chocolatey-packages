$ErrorActionPreference = 'Stop'; # stop on all errors

$packageArgs = @{
   packageName   = 'runassystem'
   FileFullPath  = Join-Path (Split-Path (Split-Path -parent $MyInvocation.MyCommand.Definition)) 'runassystem.exe'
   Url           = 'https://www.apreltech.com/Downloads/runassystem.exe'
   CheckSum      = '085AD59BB8D32981EA590A7884DA55D4B0A3F5E89A9632530C0C8EF2F379E471'
   CheckSumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'RunAsSystem.lnk'
   TargetPath       = $packageArgs.FileFullPath
   IconLocation     = Join-Path (Split-Path -parent $MyInvocation.MyCommand.Definition) 'runassystem.ico'
}

Install-ChocolateyShortcut @ShortcutArgs

