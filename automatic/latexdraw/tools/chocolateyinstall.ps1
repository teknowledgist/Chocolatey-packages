$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$Previous = Get-ChildItem $FolderOfPackage -filter "LaTeXDraw*" | Where-Object { $_.PSIsContainer }
if ($Previous) {
   $Previous | ForEach-Object { Remove-Item $_.FullName -Recurse -Force }
}

$Installer = (Get-ChildItem $ToolsDir -Filter "*.exe").FullName

$packageArgs = @{
   packageName    = $env:ChocolateyPackageName
   fileType       = 'EXE'
   file           = $Installer
   softwareName   = "$env:ChocolateyPackageName*"
   silentArgs     = '/q'
   validExitCodes = @(0)
}
Install-ChocolateyInstallPackage @packageArgs

Remove-Item $Installer -Force

