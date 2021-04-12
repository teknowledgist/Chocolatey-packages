$ErrorActionPreference = 'Stop'

# DNG Converter does not appear in 'Programs and Features' and
#   does not have an uninstaller and so manual removal is required.

# Always check/remove the .EXE and .DLL files
$InstallPath = "$env:ProgramFiles\Adobe\Adobe DNG Converter"
if (Test-Path $InstallPath) {
   Write-Verbose "Removing $env:ChocolateyPackageName executables and libraries."
   Remove-Item $InstallPath -Recurse -Force
}

# The Camera Raw definition files should be deleted too, but
#   ONLY if Adobe Bridge is not also installed because 
#   Bridge also uses Raw files (for its internal install
#   of DNG converter).  However, for now since it's not 
#   definitive how to identify all installations of Bridge,
#   this will revert to only deleting raw files if DNG
#   converter is the only Adobe app installed.

$CameraRawFiles = "$env:ProgramData\Adobe\CameraRaw"
if (Test-Path $CameraRawFiles) {
   $AdobeJunk = Get-ChildItem (Split-Path $CameraRawFiles)
   if ($AdobeJunk.count -eq 1) {
      Write-Verbose "Removing $env:ChocolateyPackageName Camera Raw definition files."
      Remove-Item $CameraRawFiles -Recurse -Force
   } else {
      Write-Verbose 'Other Adobe application files found.  To prevent accidental data loss, Camera Raw definition files will not be removed.'
   }
}

$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Adobe\Adobe DNG Converter.lnk'
if (Test-Path $StartShortcut) {
   Remove-Item $StartShortcut -Force
}

