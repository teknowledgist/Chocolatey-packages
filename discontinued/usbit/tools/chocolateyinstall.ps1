$ErrorActionPreference = 'Stop'

$ToolsDir   = Join-Path $env:ChocolateyPackageFolder 'tools'

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder -filter "$env:ChocolateyPackageName*" | ?{ $_.PSIsContainer }
if ($Previous) {
   $Previous | % { Remove-Item $_.FullName -Recurse -Force }
}

$InstallArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.zip").FullName
   Destination  = (Join-path $env:ChocolateyPackageFolder ($env:ChocolateyPackageName + "_" + $env:ChocolateyPackageVersion))
}

Get-ChocolateyUnzip @InstallArgs

$Target = (get-childitem $InstallArgs.Destination -Filter "*Tool.exe").FullName
$shortcut = Join-Path ([Environment]::GetFolderPath('Desktop')) 'USB Image Tool.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target -RunAsAdmin
