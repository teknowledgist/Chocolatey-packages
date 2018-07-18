$ProgramName = 'Spybot Anti-Beacon'

[array]$key = Get-UninstallRegistryKey -SoftwareName "$ProgramName"

if ($key.Count -eq 1) {
   # Remove any applied settings back to default
   $ABexe = Join-Path (Split-Path $key[0].UninstallString.trim('"')) 'SDAntiBeacon.exe'
   Write-Host 'Resetting tracking protections to system defaults.' -ForegroundColor Cyan
   &$ABexe /undo /silent

} elseif ($key.Count -eq 0) {
   Write-Warning "Settings for Spybot Anti-Beacon cannot be removed because the program is not installed."
} elseif ($key.Count -gt 1) {
   Write-Warning "$key.Count matches found!"
   Write-Warning "To prevent accidental data loss, No settings will be reset."
   $key | % {Write-Warning "- $_.DisplayName"}
}
