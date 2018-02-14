$ErrorActionPreference = 'Stop'

$ToolsDir   = Split-Path -parent $MyInvocation.MyCommand.Path

# Remove previous versions
$PreviousEXE = Get-ChildItem $env:ChocolateyPackageFolder -filter "clock.exe" -Recurse
if ($PreviousEXE) {
   Remove-Item (Split-Path $PreviousEXE.FullName) -Recurse -Force
}

$packageArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = (Get-ChildItem $ToolsDir -Filter "*.7z").FullName
   Destination  = Join-Path $env:ChocolateyPackageFolder "v$env:ChocolateyPackageVersion"
}

Get-ChocolateyUnzip @packageArgs

$exes = Get-ChildItem $packageArgs.Destination -filter *.exe -Recurse |select -ExpandProperty fullname
foreach ($exe in $exes) {
   if ($exe -notmatch 'clock(64)?.exe$') {
      New-Item "$exe.ignore" -Type file -Force | Out-Null
   }
}
