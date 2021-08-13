$ErrorActionPreference = 'Stop'

# Find which fonts were installed
$UnzipLog = Get-ChildItem $env:ChocolateyPackageFolder -Filter '*.zip.txt' |
                  Sort-Object creationtime | Select-Object -last 1
If ($UnzipLog) {
   $FontLines = Get-Content $UnzipLog.FullName | Where-Object {$_ -match '\.ttf$'}
   $FontFileNames = $FontLines | % { $_.split('\')[-1] }

   $Removed = Remove-Font $FontFileNames -Multiple
   
   if ($Removed -eq 0) {
      Throw 'All font removal attempts failed!'
   } elseif ($Removed -lt $FontFileNames.count) {
      Write-Host "$Removed fonts were uninstalled." -ForegroundColor Cyan
      Write-Warning "$($FontFileNames.count - $Removed) fonts in package failed to uninstall."
      Write-Warning 'They may have failed to install or may have been removed by other means.'
   } else {
      Write-Host "$Removed fonts were uninstalled."
   }
} else {
   throw "Chocolatey package $env:ChocolateyPackageName install location not found!"
}
