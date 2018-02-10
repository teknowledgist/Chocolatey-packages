Get-Process | Where-Object { $_.name -eq 'ditto' } | Stop-Process
