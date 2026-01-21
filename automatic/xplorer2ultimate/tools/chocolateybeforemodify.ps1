if (Get-Process xplorer2* -EA SilentlyContinue) {
   $ProcID = Get-Process xplorer2* |Select-Object -expand Id -EA silentlycontinue
   Stop-Process $ProcID -Force
}
