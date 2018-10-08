$StartShortcut = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\$env:ChocolateyPackageName.lnk"

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Recurse -Force
}

