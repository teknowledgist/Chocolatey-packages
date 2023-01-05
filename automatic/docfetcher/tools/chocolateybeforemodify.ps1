foreach ($item in (Get-Process "$env:ChocolateyPackageName*" -ErrorAction SilentlyContinue)) {
   Stop-Process -Name $item.Name -Force
}
