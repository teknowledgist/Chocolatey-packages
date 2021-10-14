$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Key-n-Stroke.lnk'

if(Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}

$toolsDir = Split-Path -parent $MyInvocation.MyCommand.Definition

# Self-updates get left behind, so let's clean it up a bit.
Get-ChildItem $toolsDir -filter *.exe | ForEach-Object {$null = Remove-item $_.FullName -Force}
