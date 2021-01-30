$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\BabelPad.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
