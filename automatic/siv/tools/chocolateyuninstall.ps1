$ErrorActionPreference = 'Stop'
$packageName = 'siv' 

remove-item "$env:Public\Desktop\SIV.lnk" -Force -ErrorAction SilentlyContinue
remove-item "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\SIV.lnk" -Force -ErrorAction SilentlyContinue
