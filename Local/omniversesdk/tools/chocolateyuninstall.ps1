$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Omniverse Kit SDK.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
