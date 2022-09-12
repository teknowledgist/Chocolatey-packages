$ErrorActionPreference = 'Stop'

$ToolsDir = Split-Path -parent $MyInvocation.MyCommand.Path
$FolderOfPackage = Split-Path -Parent $toolsDir

# Remove previous versions
$PreviousEXE = Get-ChildItem $FolderOfPackage -filter "clock.exe" -Recurse
if ($PreviousEXE) {
   Remove-Item (Split-Path $PreviousEXE.FullName) -Recurse -Force
}

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.7z").FullName
   Destination  = Join-Path $FolderOfPackage "v$env:ChocolateyPackageVersion"
}

Get-ChocolateyUnzip @packageArgs

$exes = Get-ChildItem $packageArgs.Destination -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   if ($exe -notmatch 'clock(64)?.exe$') {
      Remove-Item $exe -ea 0 -force
   }
}
