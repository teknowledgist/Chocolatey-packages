$StartPath = Join-Path $env:ProgramData "Microsoft\Windows\Start Menu\Programs\"

$Link = Get-ChildItem $StartPath -filter "$env:ChocolateyPackageName*"

if(Test-Path $Link.FullName) {
   Remove-Item $Link.FullName -Force
}

