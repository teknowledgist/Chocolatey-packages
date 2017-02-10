$progs32 = $env:ProgramFiles
if (Get-ProcessorBits -eq 64) {
   $progs32 = ${env:ProgramFiles(x86)}
}

$InstallArgs = @{
   PackageName = 'rasmol'
   Url = 'http://www.rasmol.org/software/RasMol_Latest_Windows_Installer.exe' 
   UnzipLocation = Join-Path $progs32 'RasMol'
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallArgs.UnzipLocation 'raswin.exe'
$shortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'RasMol.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $shortcut -TargetPath $target
