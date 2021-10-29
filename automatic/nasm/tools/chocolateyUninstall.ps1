$ErrorActionPreference = 'Stop'

# The NASM uninstaller isn't silent and hangs.  No registry entries,
#   so just remove all the files.

$StartMenu = Join-Path $env:ProgramData '\Microsoft\Windows\Start Menu'
$SMfolder = Get-ChildItem $StartMenu -Filter "Netwide Assembler*" -Recurse -Directory
if ($SMfolder) {
   $null = Remove-Item $SMfolder.FullName -Recurse -Force
   Write-Verbose "Removed NASM icons in Start Menu."
}

if (Test-Path 'C:\Users\Public\Desktop\nasm.lnk') {
   $null = Remove-Item 'C:\Users\Public\Desktop\nasm.lnk' -Force
   Write-Verbose "Removed NASM icon on public desktop."
} 

if (Test-Path "$env:ProgramFiles\NASM") {
   $null = Remove-Item "$env:ProgramFiles\NASM" -Recurse -Force
   Write-Verbose "Removed NASM folder from Program Files."
}






