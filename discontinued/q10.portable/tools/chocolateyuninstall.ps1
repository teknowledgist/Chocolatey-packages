﻿$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\Q10.lnk"

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Recurse -Force
}

