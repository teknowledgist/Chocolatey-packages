$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\PhotoResizerOK.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
