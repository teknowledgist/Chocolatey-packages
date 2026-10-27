$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter '*.exe'
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Force }
}

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $FolderOfPackage "$env:ChocolateyPackageName.exe"
   Url          = 'https://github.com/ccbogel/QualCoder/releases/download/4.0/Qualcoder-4.0_Win_PORTABLE.exe'
   Checksum     = '7faad5d20e18bd498c1f8b6840cb2d0859b4f757441cfd2aa95ee88649e61ac6'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}
$EXEfile = Get-ChocolateyWebFile @WebFileArgs

$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$ShortArgs = @{
   shortcut  = Join-Path $StartMenu 'QualCoder.lnk'
   Target    = $EXEfile
}
Install-ChocolateyShortcut @ShortArgs
