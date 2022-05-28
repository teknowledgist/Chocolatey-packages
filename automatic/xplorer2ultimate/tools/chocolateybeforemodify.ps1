if (Get-Process xplorer2* -EA SilentlyContinue) {
   $Pname = Get-Process xplorer2* |Select-Object -expand ProcessName -EA silentlycontinue
   Stop-Process $Pname -Force
}
