$packageName = 'eclipse-java-neon'

$zipFileName = 'eclipse-java-neon-R-win32.zip'
if (Get-ProcessorBits -eq 64) {
  $zipFileName = 'eclipse-java-neon-R-win32-x86_64.zip'
}

Uninstall-ChocolateyZipPackage $packageName $zipFileName

$desktop = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Eclipse Java IDE (Neon).lnk' 
if (Test-Path $desktop) {
    Write-Debug 'Found the Desktop shortcut. Deleting it...'
    Remove-Item $desktop -Force
}

$startmenu = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Eclipse Java IDE (Neon).lnk'
if (Test-Path $startmenu) {
    Write-Debug 'Found the Start Menu shortcut. Deleting it...'
    Remove-Item $startmenu -Force
}
