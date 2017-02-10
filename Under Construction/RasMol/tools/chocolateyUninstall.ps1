$progs32 = $env:ProgramFiles
if (Get-ProcessorBits -eq 64) {
   $progs32 = ${env:ProgramFiles(x86)}
}

if (test-path (Join-Path $progs32 'RasMol')) {
   Remove-Item (Join-Path $progs32 'RasMol') -Recurse -Force
}

$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'RasMol.lnk'
 
if ([System.IO.File]::Exists($shortcut)) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    [System.IO.File]::Delete($shortcut)
}