$ErrorActionPreference = 'Stop'

$ToolsDir   = Join-Path $env:ChocolateyPackageFolder 'tools'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "$env:ChocolateyPackageName*" | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter '*.zip').FullName
   Destination  = (Join-path $env:ChocolateyPackageFolder ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))
}

Get-ChocolateyUnzip @InstallArgs

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'USB Image Tool.lnk'
$targetPath = (Get-ChildItem $env:ChocolateyPackageFolder -filter '*.exe' -recurse).fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
