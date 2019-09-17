$ErrorActionPreference = 'Stop'

$toolsDir   = Split-Path -parent $MyInvocation.MyCommand.Definition

$FontsFolder = (New-Object -ComObject Shell.Application).namespace(0x14).self.path
$FontsKey = 'HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

# Find which fonts were installed
$FontFileNames = Get-ChildItem $toolsDir -Include ('*.fon','*.otf','*.ttc','*.ttf') -Recurse | 
                     Select-Object -ExpandProperty Name

If ($FontFileNames) {
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
