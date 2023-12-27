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
   Url          = 'https://github.com/ccbogel/QualCoder/releases/download/3.5/QualCoder-3.5.exe'
   Checksum     = '096c60bff32a20d3c3decb2f771dbfe16c7554417aba11a1682298b800302e3c'
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
