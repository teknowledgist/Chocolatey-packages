$packageName = 'mpw.portable'
$url         = 'https://ssl.masterpasswordapp.com/masterpassword-gui.jar'
$Checksum    = 'c3eedb0ddede3a1511fab888012d62f9749d00f525796cac0506dfbfe66a9315'
$version     = '2.4'

$installDir  = Split-Path (Split-Path -parent $script:MyInvocation.MyCommand.Path)

$installArgs = @{
   packageName   = $packageName
   FileFullPath  = Join-Path $installDir ($url.split('/')[-1] -replace '-',"-$version-")
   url           = $url
   Checksum      = $Checksum
   ChecksumType  = 'sha256'
}
$JarFile = Get-ChocolateyWebFile @installArgs

<# 
# Install-BinFile is the "proper" method, but it is somehow broken
# See:  https://github.com/chocolatey/choco/issues/1273
$ShimArgs = @{
   Name     = 'MasterPassword'
   Path     = "$env:ProgramData\Oracle\Java\javapath\javaw.exe"
   UseStart = $true
   Command  = "-jar '$JarFile'"
}
Install-BinFile @ShimArgs
#>

$icon     = Join-Path $installDir 'tools\MasterPassword.ico'
$launcher = Join-Path $env:ChocolateyInstall 'bin\MasterPassword.exe'
$JavaExe  = Join-Path $env:ProgramData 'Oracle\Java\javapath\javaw.exe'
$sg       = Join-Path $env:ChocolateyInstall 'tools\shimgen.exe'

& $sg -o $launcher -p $JavaExe -c "-jar '$JarFile'" -i $icon --gui |out-null

if (Test-Path $launcher) {
   Write-Host "Added $launcher shim for `'$JarFile`'."
}

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'MasterPassword.lnk'
   TargetPath       = Join-Path $env:ChocolateyInstall 'bin\MasterPassword.exe'
   IconLocation     = Join-Path $installDir 'tools\MasterPassword.ico'
#   Arguments        = '--shimgen-gui'
}
Install-ChocolateyShortcut @ShortcutArgs
