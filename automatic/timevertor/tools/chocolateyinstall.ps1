$ErrorActionPreference = 'Stop'

$ToolsDir = Join-Path $env:ChocolateyPackageFolder 'tools'
$BitLevel = Get-ProcessorBits

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "$env:ChocolateyPackageName*" | 
               Where-Object{ $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = (Get-ChildItem $ToolsDir -Filter '*.zip').FullName
   SpecificFolder = "$env:ChocolateyPackageName\$BitLevel"
   Destination    = (Join-path $env:ChocolateyPackageFolder ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))
}
Get-ChocolateyUnzip @InstallArgs

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'TimeVertor.lnk'
$targetPath = (Get-ChildItem $InstallArgs.Destination -filter '*.exe' -recurse).fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
