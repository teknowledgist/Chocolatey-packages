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
   Url          = 'https://github.com/ccbogel/QualCoder/releases/download/3.8.2/QualCoder_3_8_2_Win_Portable.exe'
   Checksum     = 'ca399c7917345a98ff7d86aba1991d030c43eee45ef4ef2ffd6cf66df3cd2ed5'
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
