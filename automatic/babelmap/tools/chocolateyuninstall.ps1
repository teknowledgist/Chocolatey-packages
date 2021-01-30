$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\BabelMap.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
