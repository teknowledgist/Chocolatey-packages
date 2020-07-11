$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\USB Image Tool.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
