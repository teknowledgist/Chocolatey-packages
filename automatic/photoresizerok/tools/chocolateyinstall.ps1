$ErrorActionPreference = 'Stop'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "*.exe" 
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Force }
}

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition
$BitLevel = Get-ProcessorBits

$ZipFiles = Get-ChildItem -Path $toolsDir -filter '*.zip' |
                  Sort-Object lastwritetime | Select-Object -Last 2 -ExpandProperty FullName

if ($BitLevel -eq '64') {
   $ZipFile = $ZipFiles | Where-Object {$_ -match 'x64'} 
} else {
   $ZipFile = $ZipFiles | Where-Object {$_ -notmatch 'x64'}
}

$UnZipArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = $ZipFile
   Destination  = $env:ChocolateyPackageFolder
}
Get-ChocolateyUnzip @UnZipArgs

$GUI = (Get-ChildItem $env:ChocolateyPackageFolder -filter *.exe).fullname
$null = New-Item "$GUI.gui" -Type file -Force

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path $StartPrograms "PhotoResizerOK.lnk"
   TargetPath = $GUI
}
Install-ChocolateyShortcut @ShortcutArgs
