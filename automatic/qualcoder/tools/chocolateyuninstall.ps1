$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\QualCoder.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
