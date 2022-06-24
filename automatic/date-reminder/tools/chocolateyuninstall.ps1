$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Reminder.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}
