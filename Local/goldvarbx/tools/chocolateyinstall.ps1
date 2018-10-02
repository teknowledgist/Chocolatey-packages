$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$ZipFile = (Get-ChildItem $toolsDir -Filter '*.zip').FullName

Get-ChocolateyUnzip -FileFullPath $ZipFile -Destination $env:ChocolateyPackageFolder

$target   = Join-Path $env:ChocolateyPackageFolder 'goldvarb.exe'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Goldvarb X.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target

