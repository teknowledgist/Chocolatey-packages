$RegXtra = ''
If (Get-OSArchitectureWidth -Compare 64) {
   $RegXtra = '\Wow6432Node'
}
$RegPath = "HKLM:\SOFTWARE$RegXtra\Lame For Audacity"

if (Test-Path $RegPath) {
   Remove-Item $RegPath -Recurse -Force
}

