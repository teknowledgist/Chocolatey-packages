$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\OpenRefine.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
