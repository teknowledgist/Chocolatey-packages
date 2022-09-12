$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$FolderOfPackage = Split-Path -Parent $toolsDir
$BitLevel = Get-ProcessorBits

# Remove old versions
$null = Get-ChildItem $FolderOfPackage -Filter *.exe | Remove-Item -Force

$ZipFile = Get-ChildItem $toolsDir -filter "*.zip" |
               Where-Object {$_.basename -match "$BitLevel`$"} | 
               Sort-Object LastWriteTime | 
               Select-Object -ExpandProperty FullName -Last 1

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $FolderOfPackage

$Linkname = (Get-Culture).textinfo.totitlecase($env:ChocolateyPackageName) + '.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname
$targetPath = (Get-ChildItem $FolderOfPackage -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $FolderOfPackage -filter *.exe |Select-Object -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}
