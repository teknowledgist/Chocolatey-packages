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


$AllFontFiles = Get-ChildItem $UnzipDir -Include "*.TTF" -Recurse | 
                  Select-Object -ExpandProperty FullName

if ($pp = Get-PackageParameters) {
   $TargetFontFiles = @()
   if ($pp.contains('39')) {
      $TargetFontFiles += $AllFontFiles | Where-Object {$_ -match '39[^e]'}
   }
   if ($pp.contains('39e')) {
      $TargetFontFiles += $AllFontFiles | Where-Object {$_ -match '39e'}
   }
   if ($pp.contains('128')) {
      $TargetFontFiles += $AllFontFiles | Where-Object {$_ -match '128'}
   }
   if ($pp.contains('13')) {
      $TargetFontFiles += $AllFontFiles | Where-Object {$_ -match '13'}
   }
} else {
   $TargetFontFiles = $AllFontFiles
}

$Installed = Add-Font $TargetFontFiles -Multiple

If ($Installed -eq 0) {
   Throw 'All font installation attempts failed!'
} elseif ($Installed -lt $TargetFontFiles.count) {
   Write-Host "$Installed fonts were installed." -ForegroundColor Cyan
   Write-Warning "$($FontFiles.count - $Installed) submitted font paths failed to install."
} else {
   Write-Host "$Installed fonts were installed."
}

Remove-Item $fileLocation -Force