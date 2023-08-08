$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip').FullName
$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$RepoVersion = '3.008'

$UnzipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $fileLocation
   Destination    = $UnzipDir
   SpecificFolder = "Roboto_v$RepoVersion\hinted\static"
}
Get-ChocolateyUnzip @UnzipArgs

$pp = Get-PackageParameters

$FontFiles = Get-ChildItem $UnzipDir -Include "*.TTF" -Recurse | 
                  Select-Object -ExpandProperty FullName

if ($pp.contains('Condensed')) {
   if (-not $pp.contains('Normal')) {
      $FontFiles = $FontFiles | Where-Object {$_ -match 'Condensed'}
   }
} elseif ($pp.contains('Normal')) {
   $FontFiles = $FontFiles | Where-Object {$_ -notmatch 'Condensed'}
}

$Installed = Add-Font $FontFiles -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $FontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

Remove-Item $fileLocation -Force
