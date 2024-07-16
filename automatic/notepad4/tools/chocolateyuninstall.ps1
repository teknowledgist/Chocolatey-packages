$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Notepad4.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}

# For future user profiles
$Default = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList').Default
if (Test-Path "$Default\AppData\Local\Notepad4") {
   Remove-Item "$Default\AppData\Local\Notepad4" -Recurse -Force
}
