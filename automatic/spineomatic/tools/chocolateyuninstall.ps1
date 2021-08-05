$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\SpineOMatic.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}

$pp = Get-PackageParameters

if ($pp['path']) {
   $RemoveEXE = Join-Path $pp['path'] 'SpineLabeler.exe'
} else {
   $RemoveEXE = 'C:\Spine\SpineLabeler.exe'
}

if (Test-Path $RemoveEXE) {
   $null = Remove-Item $RemoveEXE -Force
}