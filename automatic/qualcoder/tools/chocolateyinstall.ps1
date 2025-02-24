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
   Url          = 'https://github.com/ccbogel/QualCoder/releases/download/3.6/Windows-QualCoder-3.6.exe'
   Checksum     = 'cbf8d3cc7c8765e38e5cd5bc05fa188617eb53b324f90f955fd280d2c0808602'
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
