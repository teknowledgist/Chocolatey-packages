$SCRfilePath = Join-Path $env:Windir "TheMatrix.scr"

if(Test-Path $SCRfilePath) {
   Remove-Item "$env:Windir\TheMatrix.scr" -Force
}

