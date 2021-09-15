$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition
$fileLocation = (Get-ChildItem -Path $toolsDir -Filter '*.zip').FullName
$UnzipDir = Join-Path $env:TEMP $env:ChocolateyPackageName

$UnzipArgs = @{
   packageName    = $env:ChocolateyPackageName
   FileFullPath   = $fileLocation
   Destination    = $UnzipDir
}
Get-ChocolateyUnzip @UnzipArgs

$pp = Get-PackageParameters

if ($pp.contains('TTF')) { $EXT = 'TTF' }
else { $EXT = 'OTF' }

$FontFiles = Get-ChildItem $UnzipDir -Include "*.$EXT" -Recurse | 
                  Select-Object -ExpandProperty FullName

if (-not $pp.contains('both')) {
   if (-not $pp.contains('alt')) {
      $FontFiles = $FontFiles | Where-Object {$_ -notmatch 'alternates'}
   } else {
      $FontFiles = $FontFiles | Where-Object {$_ -match 'alternates'}
   }
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