$ErrorActionPreference = 'Stop'

$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$PackageFolder = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $PackageFolder -filter "$env:ChocolateyPackageName*" | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter '*.zip').FullName
   Destination  = (Join-path $PackageFolder ($env:ChocolateyPackageName + '_' + $env:ChocolateyPackageVersion))
}

Get-ChocolateyUnzip @InstallArgs

$StartPrograms = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu\Programs'
$shortcutFilePath = Join-Path $StartPrograms 'USB Image Tool.lnk'
$targetPath = (Get-ChildItem $PackageFolder -filter '*tool.exe' -recurse).fullname

Install-ChocolateyShortcut -shortcutFilePath $shortcutFilePath -targetPath $targetPath
