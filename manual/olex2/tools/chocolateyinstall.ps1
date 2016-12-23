$packageName = 'Olex2'

$InstallDir = Join-Path $env:ProgramData $packageName

$InstallArgs = @{
   PackageName = $packageName
   Url = 'http://www.olex2.org/olex2-distro/1.2/olex2-win32.zip'
   Url64 = 'http://www.olex2.org/olex2-distro/1.2/olex2-win64.zip'
   UnzipLocation = $InstallDir
   checkSum = 'CA892D9D9908A518A8DC43A08A5AC830264C578638DF1AE5E3394A74A3C13AB9'
   checkSum64 = '8DEAC6CC55726983AA525969FB24FAD364B65758900B2B64235F32254511AE4A'
   checkSumType = 'sha256'
}
Install-ChocolateyZipPackage @InstallArgs

$target   = Join-Path $InstallDir 'olex2.exe'
$DeskShortcut = Join-Path ([System.Environment]::GetFolderPath('Desktop')) 'Olex2-1.2.lnk'
$StartShortcut = Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs\Olex2-1.2.lnk'

Install-ChocolateyShortcut -ShortcutFilePath $DeskShortcut -TargetPath $target
Install-ChocolateyShortcut -ShortcutFilePath $StartShortcut -TargetPath $target
