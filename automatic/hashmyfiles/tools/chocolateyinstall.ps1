$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$BitLevel = Get-ProcessorBits

$ZipFile   = (Get-ChildItem $toolsDir -filter "*.zip" |
               Where-Object {$_.basename -match "$BitLevel`$"}).FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $env:ChocolateyPackageFolder

$Linkname = 'HashMyFiles.lnk'
$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms $Linkname
$targetPath = (Get-ChildItem $env:ChocolateyPackageFolder -filter "*.exe").fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath

$exes = Get-ChildItem $env:ChocolateyPackageFolder -filter *.exe |select -ExpandProperty fullname
foreach ($exe in $exes) {
   $null = New-Item "$exe.gui" -Type file -Force
}
