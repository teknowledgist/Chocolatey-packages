$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\Tabular Editor.lnk"

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Recurse -Force
}

