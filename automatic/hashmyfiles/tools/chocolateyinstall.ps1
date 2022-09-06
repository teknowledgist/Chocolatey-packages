$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir
$BitLevel = Get-ProcessorBits

# Remove old versions
$null = Get-ChildItem $PackageFolder -Filter *.exe | Remove-Item -Force

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Where-Object {$_.basename -match "$BitLevel`$"} | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $PackageFolder

$Linkname = 'HashMyFiles.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname
$targetPath = (Get-ChildItem $PackageFolder -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $PackageFolder -filter *.exe |select -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}
