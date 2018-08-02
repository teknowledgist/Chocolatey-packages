$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

# Remove previous versions
$Previous = Get-ChildItem $env:ChocolateyPackageFolder | 
Where-Object{($_.name -match 'v[0-9.]+') -and $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$InstallerLocation = (Get-ChildItem -Path $toolsDir -Filter '*.exe').FullName

$packageArgs = @{
   FileFullPath = $InstallerLocation
   Destination  = (Join-Path $env:ChocolateyPackageFolder "v$env:ChocolateyPackageVersion")
}

Get-ChocolateyUnzip @packageArgs

New-Item "$InstallerLocation.ignore" -Type file -Force | Out-Null
New-Item (Join-path $packageArgs.Destination "uninstall.exe.ignore") -Type file -Force | Out-Null

$ShortcutArgs = @{
   TargetPath = (Get-ChildItem $packageArgs.Destination -filter Analyzer.exe -Recurse).fullname
   ShortcutFilePath = (Join-Path ([Environment]::GetFolderPath("commonstartmenu")) 'Programs\Image Analyzer.lnk')
}

Install-ChocolateyShortcut @ShortcutArgs
