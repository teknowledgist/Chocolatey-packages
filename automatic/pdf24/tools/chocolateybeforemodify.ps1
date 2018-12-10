if (Get-Process 'pdf24' -ErrorAction SilentlyContinue) {
   Stop-Process -Name pdf24 -Force
}
