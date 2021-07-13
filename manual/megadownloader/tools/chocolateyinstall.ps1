$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# Remove old versions
$null = Get-ChildItem $env:ChocolateyPackageFolder -Filter *.exe | Remove-Item -Force

$RARfile = Get-ChildItem $toolsDir -filter "*.rar" |
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $RARfile -Destination $env:ChocolateyPackageFolder

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'MegaDownloader.lnk'
$targetPath = (Get-ChildItem $env:ChocolateyPackageFolder -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $env:ChocolateyPackageFolder -filter *.exe |select -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}
